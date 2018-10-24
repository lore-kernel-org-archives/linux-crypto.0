Return-Path: <SRS0=schb=NE=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:48099 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbeJXLwU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Oct 2018 07:52:20 -0400
Date: Wed, 24 Oct 2018 03:03:15 +0300 (EEST)
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v4 5/7] trusted keys: Add session encryption protection
 to the seal/unseal path
In-Reply-To: <1540193921.3202.13.camel@HansenPartnership.com>
Message-ID: <alpine.DEB.2.21.1810240259390.8524@jsakkine-mobl1>
References: <1540193596.3202.7.camel@HansenPartnership.com> <1540193921.3202.13.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1231958307-1540339399=:8524"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1231958307-1540339399=:8524
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

The tag in the short description does not look at all. Should be either
"tpm:" or "keys, trusted:".

On Mon, 22 Oct 2018, James Bottomley wrote:
> If some entity is snooping the TPM bus, the can see the data going in
> to be sealed and the data coming out as it is unsealed.  Add parameter
> and response encryption to these cases to ensure that no secrets are
> leaked even if the bus is snooped.
>
> As part of doing this conversion it was discovered that policy
> sessions can't work with HMAC protected authority because of missing
> pieces (the tpm Nonce).  I've added code to work the same way as
> before, which will result in potential authority exposure (while still
> adding security for the command and the returned blob), and a fixme to
> redo the API to get rid of this security hole.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
> drivers/char/tpm/tpm2-cmd.c | 155 ++++++++++++++++++++++++++++----------------
> 1 file changed, 98 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 22f1c7bee173..a8655cd535d1 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -425,7 +425,9 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
> {
> 	unsigned int blob_len;
> 	struct tpm_buf buf;
> +	struct tpm_buf t2b;
> 	u32 hash;
> +	struct tpm2_auth *auth;
> 	int i;
> 	int rc;
>
> @@ -439,45 +441,56 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
> 	if (i == ARRAY_SIZE(tpm2_hash_map))
> 		return -EINVAL;
>
> -	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
> +	rc = tpm2_start_auth_session(chip, &auth);
> 	if (rc)
> 		return rc;
>
> -	tpm_buf_append_u32(&buf, options->keyhandle);
> -	tpm2_buf_append_auth(&buf, TPM2_RS_PW,
> -			     NULL /* nonce */, 0,
> -			     0 /* session_attributes */,
> -			     options->keyauth /* hmac */,
> -			     TPM_DIGEST_SIZE);
> +	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
> +	if (rc) {
> +		tpm2_end_auth_session(auth);
> +		return rc;
> +	}
> +
> +	rc = tpm_buf_init_2b(&t2b);
> +	if (rc) {
> +		tpm_buf_destroy(&buf);
> +		tpm2_end_auth_session(auth);
> +		return rc;
> +	}
>
> +	tpm_buf_append_name(&buf, auth, options->keyhandle, NULL);
> +	tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_DECRYPT,
> +				    options->keyauth, TPM_DIGEST_SIZE);
> 	/* sensitive */
> -	tpm_buf_append_u16(&buf, 4 + TPM_DIGEST_SIZE + payload->key_len + 1);
> +	tpm_buf_append_u16(&t2b, TPM_DIGEST_SIZE);
> +	tpm_buf_append(&t2b, options->blobauth, TPM_DIGEST_SIZE);
> +	tpm_buf_append_u16(&t2b, payload->key_len + 1);
> +	tpm_buf_append(&t2b, payload->key, payload->key_len);
> +	tpm_buf_append_u8(&t2b, payload->migratable);
>
> -	tpm_buf_append_u16(&buf, TPM_DIGEST_SIZE);
> -	tpm_buf_append(&buf, options->blobauth, TPM_DIGEST_SIZE);
> -	tpm_buf_append_u16(&buf, payload->key_len + 1);
> -	tpm_buf_append(&buf, payload->key, payload->key_len);
> -	tpm_buf_append_u8(&buf, payload->migratable);
> +	tpm_buf_append_2b(&buf, &t2b);
>
> 	/* public */
> -	tpm_buf_append_u16(&buf, 14 + options->policydigest_len);
> -	tpm_buf_append_u16(&buf, TPM2_ALG_KEYEDHASH);
> -	tpm_buf_append_u16(&buf, hash);
> +	tpm_buf_append_u16(&t2b, TPM2_ALG_KEYEDHASH);
> +	tpm_buf_append_u16(&t2b, hash);
>
> 	/* policy */
> 	if (options->policydigest_len) {
> -		tpm_buf_append_u32(&buf, 0);
> -		tpm_buf_append_u16(&buf, options->policydigest_len);
> -		tpm_buf_append(&buf, options->policydigest,
> +		tpm_buf_append_u32(&t2b, 0);
> +		tpm_buf_append_u16(&t2b, options->policydigest_len);
> +		tpm_buf_append(&t2b, options->policydigest,
> 			       options->policydigest_len);
> 	} else {
> -		tpm_buf_append_u32(&buf, TPM2_OA_USER_WITH_AUTH);
> -		tpm_buf_append_u16(&buf, 0);
> +		tpm_buf_append_u32(&t2b, TPM2_OA_USER_WITH_AUTH);
> +		tpm_buf_append_u16(&t2b, 0);
> 	}
>
> 	/* public parameters */
> -	tpm_buf_append_u16(&buf, TPM2_ALG_NULL);
> -	tpm_buf_append_u16(&buf, 0);
> +	tpm_buf_append_u16(&t2b, TPM2_ALG_NULL);
> +	/* unique (zero) */
> +	tpm_buf_append_u16(&t2b, 0);
> +
> +	tpm_buf_append_2b(&buf, &t2b);
>
> 	/* outside info */
> 	tpm_buf_append_u16(&buf, 0);
> @@ -490,8 +503,11 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
> 		goto out;
> 	}
>
> -	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 4, 0,
> -			      "sealing data");
> +	tpm_buf_fill_hmac_session(&buf, auth);
> +
> +	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data,
> +			      PAGE_SIZE, 4, 0, "sealing data");
> +	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
> 	if (rc)
> 		goto out;
>
> @@ -509,6 +525,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
> 	payload->blob_len = blob_len;
>
> out:
> +	tpm_buf_destroy(&t2b);
> 	tpm_buf_destroy(&buf);
>
> 	if (rc > 0) {
> @@ -528,7 +545,6 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
>  * @payload: the key data in clear and encrypted form
>  * @options: authentication values and other options
>  * @blob_handle: returned blob handle
> - * @flags: tpm transmit flags
>  *
>  * Return: 0 on success.
>  *        -E2BIG on wrong payload size.
> @@ -538,9 +554,10 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
> static int tpm2_load_cmd(struct tpm_chip *chip,
> 			 struct trusted_key_payload *payload,
> 			 struct trusted_key_options *options,
> -			 u32 *blob_handle, unsigned int flags)
> +			 u32 *blob_handle)
> {
> 	struct tpm_buf buf;
> +	struct tpm2_auth *auth;
> 	unsigned int private_len;
> 	unsigned int public_len;
> 	unsigned int blob_len;
> @@ -555,17 +572,18 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
> 	if (blob_len > payload->blob_len)
> 		return -E2BIG;
>
> -	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
> +	rc = tpm2_start_auth_session(chip, &auth);
> 	if (rc)
> 		return rc;
>
> -	tpm_buf_append_u32(&buf, options->keyhandle);
> -	tpm2_buf_append_auth(&buf, TPM2_RS_PW,
> -			     NULL /* nonce */, 0,
> -			     0 /* session_attributes */,
> -			     options->keyauth /* hmac */,
> -			     TPM_DIGEST_SIZE);
> +	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_LOAD);
> +	if (rc) {
> +		tpm2_end_auth_session(auth);
> +		return rc;
> +	}
>
> +	tpm_buf_append_name(&buf, auth, options->keyhandle, NULL);
> +	tpm_buf_append_hmac_session(&buf, auth, 0, options->keyauth, TPM_DIGEST_SIZE);
> 	tpm_buf_append(&buf, payload->blob, blob_len);
>
> 	if (buf.flags & TPM_BUF_OVERFLOW) {
> @@ -573,8 +591,10 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
> 		goto out;
> 	}
>
> -	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 4, flags,
> -			      "loading blob");
> +	tpm_buf_fill_hmac_session(&buf, auth);
> +	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
> +			      4, 0, "loading blob");
> +	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
> 	if (!rc)
> 		*blob_handle = be32_to_cpup(
> 			(__be32 *) &buf.data[TPM_HEADER_SIZE]);
> @@ -595,7 +615,6 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
>  * @payload: the key data in clear and encrypted form
>  * @options: authentication values and other options
>  * @blob_handle: blob handle
> - * @flags: tpm_transmit_cmd flags
>  *
>  * Return: 0 on success
>  *         -EPERM on tpm error status
> @@ -604,28 +623,54 @@ static int tpm2_load_cmd(struct tpm_chip *chip,
> static int tpm2_unseal_cmd(struct tpm_chip *chip,
> 			   struct trusted_key_payload *payload,
> 			   struct trusted_key_options *options,
> -			   u32 blob_handle, unsigned int flags)
> +			   u32 blob_handle)
> {
> 	struct tpm_buf buf;
> +	struct tpm2_auth *auth;
> 	u16 data_len;
> 	u8 *data;
> 	int rc;
>
> -	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
> +	rc = tpm2_start_auth_session(chip, &auth);
> 	if (rc)
> 		return rc;
>
> -	tpm_buf_append_u32(&buf, blob_handle);
> -	tpm2_buf_append_auth(&buf,
> -			     options->policyhandle ?
> -			     options->policyhandle : TPM2_RS_PW,
> -			     NULL /* nonce */, 0,
> -			     TPM2_SA_CONTINUE_SESSION,
> -			     options->blobauth /* hmac */,
> -			     TPM_DIGEST_SIZE);
> -
> -	rc = tpm_transmit_cmd(chip, NULL, buf.data, PAGE_SIZE, 6, flags,
> -			      "unsealing");
> +	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_UNSEAL);
> +	if (rc) {
> +		tpm2_end_auth_session(auth);
> +		return rc;
> +	}
> +
> +	tpm_buf_append_name(&buf, auth, blob_handle, NULL);
> +
> +	if (!options->policyhandle) {
> +		tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_ENCRYPT,
> +					    options->blobauth, TPM_DIGEST_SIZE);
> +	} else {
> +		/*
> +		 * FIXME: the policy can't be used for HMAC protection
> +		 * of the authorization because it must be generated
> +		 * with the initial nonces which isn't passed in, so
> +		 * append a second encryption session to at least HMAC
> +		 * protect the command and encrypt the sealed blob on
> +		 * return so the only thing the attacker can get is
> +		 * the password.
> +		 *
> +		 * We also consume the policy session otherwise it
> +		 * would be absorbed into the kernel space.
> +		 */
> +		tpm2_buf_append_auth(&buf, options->policyhandle,
> +				     NULL /* nonce */, 0, 0,
> +				     options->blobauth /* hmac */,
> +				     TPM_DIGEST_SIZE);
> +		tpm_buf_append_hmac_session(&buf, auth, TPM2_SA_ENCRYPT,
> +					    NULL, 0);
> +	}
> +
> +	tpm_buf_fill_hmac_session(&buf, auth);
> +	rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
> +			      6, 0, "unsealing");
> +	rc = tpm_buf_check_hmac_response(&buf, auth, rc);
> 	if (rc > 0)
> 		rc = -EPERM;
>
> @@ -669,17 +714,13 @@ int tpm2_unseal_trusted(struct tpm_chip *chip,
> 	u32 blob_handle;
> 	int rc;
>
> -	mutex_lock(&chip->tpm_mutex);
> -	rc = tpm2_load_cmd(chip, payload, options, &blob_handle,
> -			   TPM_TRANSMIT_UNLOCKED);
> +	rc = tpm2_load_cmd(chip, payload, options, &blob_handle);
> 	if (rc)
> 		goto out;
>
> -	rc = tpm2_unseal_cmd(chip, payload, options, blob_handle,
> -			     TPM_TRANSMIT_UNLOCKED);
> -	tpm2_flush_context_cmd(chip, blob_handle, TPM_TRANSMIT_UNLOCKED);
> +	rc = tpm2_unseal_cmd(chip, payload, options, blob_handle);
> +	tpm2_flush_context_cmd(chip, blob_handle, 0);
> out:
> -	mutex_unlock(&chip->tpm_mutex);
> 	return rc;
> }
>
> -- 
> 2.16.4
>
>

This commit makes me almost demand a preliminary patch set that just
does the groundwork and takes new stuff into use (tpm2b).

BTW, the whole patch set should speak integrity and encryption.
"security" essentially means absolutely nothing.

/Jarkko
--8323329-1231958307-1540339399=:8524--
