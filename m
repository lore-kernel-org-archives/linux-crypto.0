Return-Path: <SRS0=9uPW=NC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07474C7112C
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Oct 2018 22:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A66720663
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Oct 2018 22:19:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZSYoZLA/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A66720663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbeJWGjy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Oct 2018 02:39:54 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42478 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbeJWGjy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Oct 2018 02:39:54 -0400
Received: by mail-io1-f66.google.com with SMTP id n18-v6so28041278ioa.9
        for <linux-crypto@vger.kernel.org>; Mon, 22 Oct 2018 15:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=SxVLKQmE7fOmWd6Xjx3S0wCFta6R5rDWL8vY1KBCmkA=;
        b=ZSYoZLA/yajkNsHHOOWiFBKGpaUmws2/eKvBQgXLd8L4dKPKVTPNJOrZG8AHKkqxEb
         eOCvNsuZgJ49AFa3DTtfObOnQVRigiJSWFQElJPDpYzZCodyKLZ/ZVw1NW2sCWOO3eSk
         WoL2HcyNoh/aEgSqDdDXOZZOPdfbTWIXPetv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=SxVLKQmE7fOmWd6Xjx3S0wCFta6R5rDWL8vY1KBCmkA=;
        b=lFaSv6jqiHjiJabcMlR2AEgxm7tnFczTIU7QtxyMkhX2tWQxBq29tfOijsD6f67Kbw
         kY4OeykM6dKZiNJyRdUe2Cs4QmJHoKv81WYQa3zN9Z0soZVtnUViBKBq4C8rXAm5hK+1
         /Ec4YSBmgEYkEak3C2WtKrL89EebWalG5f4VUpDrQDH1wSFn1F8QErYWEf/yZ3lteV+7
         c2kAIUZaHBFJPjeM2i+y+owTMTBMGD3p5irK+xNCsK9q+uAzhh5bb787XALU0wrKez/3
         AAS8ir4y/WQKv7VHM4V8cdvm5EqEkf4o8XuCKdaXvON0wRehuLiCZw/sAKEtgj5OnEEQ
         f73A==
X-Gm-Message-State: AGRZ1gKAVLaoPVclXIJDU1CPg6GyTr95pAZY7FFoFL5FQFSMQaKJ/n1A
        kNYpuGkbdCODKtpNNXrOaXYNTU8oR5Nn7u07abLtiZGpq4E=
X-Google-Smtp-Source: AJdET5fqOBwq5GVGYThLSlqlmUCL7jffeLggZpWSFVTBsx+N92tx0hYtAND3B4lAvyT1ykscIZ3dO4XSpEWFGQk9ngE=
X-Received: by 2002:a6b:5d12:: with SMTP id r18-v6mr9616616iob.170.1540246768466;
 Mon, 22 Oct 2018 15:19:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Mon, 22 Oct 2018 15:19:27
 -0700 (PDT)
In-Reply-To: <1540193787.3202.10.camel@HansenPartnership.com>
References: <1540193596.3202.7.camel@HansenPartnership.com> <1540193787.3202.10.camel@HansenPartnership.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 22 Oct 2018 19:19:27 -0300
Message-ID:
 <CAKv+Gu-gYLY1vmtgFC0MTkBfsAkPz658ELaGW78MbD=6ROrLFQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/7] tpm2-sessions: Add full HMAC and encrypt/decrypt
 session handling
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     linux-integrity <linux-integrity@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181022221927.TvJLCgAf1pAPHOMpuy-FW2g5FNl9BwTCGHmu-9Ap0JA@z>

Hi James,

Some comments below on how you are using the crypto API.

On 22 October 2018 at 04:36, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> This code adds true session based HMAC authentication plus parameter
> decryption and response encryption using AES.
>
> The basic design of this code is to segregate all the nasty crypto,
> hash and hmac code into tpm2-sessions.c and export a usable API.
>
> The API first of all starts off by gaining a session with
>
> tpm2_start_auth_session()
>
> Which initiates a session with the TPM and allocates an opaque
> tpm2_auth structure to handle the session parameters.  Then the use is
> simply:
>
> * tpm_buf_append_name() in place of the tpm_buf_append_u32 for the
>   handles
>
> * tpm_buf_append_hmac_session() where tpm2_append_auth() would go
>
> * tpm_buf_fill_hmac_session() called after the entire command buffer
>   is finished but before tpm_transmit_cmd() is called which computes
>   the correct HMAC and places it in the command at the correct
>   location.
>
> Finally, after tpm_transmit_cmd() is called,
> tpm_buf_check_hmac_response() is called to check that the returned
> HMAC matched and collect the new state for the next use of the
> session, if any.
>
> The features of the session is controlled by the session attributes
> set in tpm_buf_append_hmac_session().  If TPM2_SA_CONTINUE_SESSION is
> not specified, the session will be flushed and the tpm2_auth structure
> freed in tpm_buf_check_hmac_response(); otherwise the session may be
> used again.  Parameter encryption is specified by or'ing the flag
> TPM2_SA_DECRYPT and response encryption by or'ing the flag
> TPM2_SA_ENCRYPT.  the various encryptions will be taken care of by
> tpm_buf_fill_hmac_session() and tpm_buf_check_hmac_response()
> respectively.
>
> To get all of this to work securely, the Kernel now needs a primary
> key to encrypt the session salt to, so we derive an EC key from the
> NULL seed and store it in the tpm_chip structure.  We also make sure
> that this seed remains for the kernel by using a kernel space to take
> it out of the TPM when userspace wants to use it.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>
> ---
>
> v2: Added docbook and improved response check API
> v3: Add readpublic, fix hmac length, add API for close on error
>     allow for the hmac session not being first in the sessions
> v4: Make NULL seed template exactly match the SRK ECC template.
>     Also check the NULL primary key name is what getpublic returns
>     to prevent spoofing.  Also parametrise the name size for reuse
> ---
>  drivers/char/tpm/Kconfig         |    3 +
>  drivers/char/tpm/Makefile        |    2 +-
>  drivers/char/tpm/tpm.h           |   32 +
>  drivers/char/tpm/tpm2-cmd.c      |   34 +-
>  drivers/char/tpm/tpm2-sessions.c | 1188 ++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm2-sessions.h |   57 ++
>  6 files changed, 1300 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm2-sessions.c
>  create mode 100644 drivers/char/tpm/tpm2-sessions.h
>
...
> diff --git a/drivers/char/tpm/tpm2-sessions.c b/drivers/char/tpm/tpm2-sessions.c
> new file mode 100644
> index 000000000000..422c3ec64f8c
> --- /dev/null
> +++ b/drivers/char/tpm/tpm2-sessions.c
> @@ -0,0 +1,1188 @@
...
> +/*
> + * this is our static crypto shash.  This is possible because the hash
> + * is multi-threaded and all the state stored in the desc
> + */
> +static struct crypto_shash *sha256_hash;
> +
> +/*
> + * It turns out the crypto hmac(sha256) is hard for us to consume
> + * because it assumes a fixed key and the TPM seems to change the key
> + * on every operation, so we weld the hmac init and final functions in
> + * here to give it the same usage characteristics as a regular hash
> + */
> +static void hmac_init(struct shash_desc *desc, u8 *key, int keylen)
> +{
> +       u8 pad[SHA256_BLOCK_SIZE];
> +       int i;
> +
> +       desc->tfm = sha256_hash;
> +       desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;

I don't think this actually does anything in the shash API
implementation, so you can drop this. However, I take it this means
that hmac_init() is never called in contexts where sleeping is not
allowed? For the relevance of that, please see below.

> +       crypto_shash_init(desc);
> +       for (i = 0; i < sizeof(pad); i++) {
> +               if (i < keylen)
> +                       pad[i] = key[i];
> +               else
> +                       pad[i] = 0;
> +               pad[i] ^= HMAC_IPAD_VALUE;
> +       }
> +       crypto_shash_update(desc, pad, sizeof(pad));
> +}
> +
> +static void hmac_final(struct shash_desc *desc, u8 *key, int keylen, u8 *out)
> +{
> +       u8 pad[SHA256_BLOCK_SIZE];
> +       int i;
> +
> +       for (i = 0; i < sizeof(pad); i++) {
> +               if (i < keylen)
> +                       pad[i] = key[i];
> +               else
> +                       pad[i] = 0;
> +               pad[i] ^= HMAC_OPAD_VALUE;
> +       }
> +
> +       /* collect the final hash;  use out as temporary storage */
> +       crypto_shash_final(desc, out);
> +
> +       /* reuse the desc */
> +       crypto_shash_init(desc);
> +       crypto_shash_update(desc, pad, sizeof(pad));
> +       crypto_shash_update(desc, out, SHA256_DIGEST_SIZE);
> +       crypto_shash_final(desc, out);
> +}
> +
...
> +/**
> + * tpm_buf_fill_hmac_session() - finalize the session HMAC
> + * @buf: The buffer to be appended
> + * @auth: the auth structure allocated by tpm2_start_auth_session()
> + *
> + * This command must not be called until all of the parameters have
> + * been appended to @buf otherwise the computed HMAC will be
> + * incorrect.
> + *
> + * This function computes and fills in the session HMAC using the
> + * session key and, if TPM2_SA_DECRYPT was specified, computes the
> + * encryption key and encrypts the first parameter of the command
> + * buffer with it.
> + *
> + * As with most tpm_buf operations, success is assumed because failure
> + * will be caused by an incorrect programming model and indicated by a
> + * kernel message.
> + */
> +void tpm_buf_fill_hmac_session(struct tpm_buf *buf, struct tpm2_auth *auth)
> +{
> +       u32 cc, handles, val;
> +       struct tpm_chip *chip = auth->chip;
> +       int i;
> +       struct tpm_input_header *head = (struct tpm_input_header *)buf->data;
> +       const u8 *s, *p;
> +       u8 *hmac = NULL;
> +       u32 attrs;
> +       u8 cphash[SHA256_DIGEST_SIZE];
> +       SHASH_DESC_ON_STACK(desc, sha256_hash);
> +
> +       /* save the command code in BE format */
> +       auth->ordinal = head->ordinal;
> +
> +       desc->tfm = sha256_hash;
> +       desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +

Same here.

> +       cc = be32_to_cpu(head->ordinal);
> +
> +       i = tpm2_find_cc(chip, cc);
> +       if (i < 0) {
> +               dev_err(&chip->dev, "Command 0x%x not found in TPM\n", cc);
> +               return;
> +       }
> +       attrs = chip->cc_attrs_tbl[i];
> +
> +       handles = (attrs >> TPM2_CC_ATTR_CHANDLES) & GENMASK(2, 0);
> +
> +       s = &buf->data[TPM_HEADER_SIZE];
> +       /*
> +        * just check the names, it's easy to make mistakes.  This
> +        * would happen if someone added a handle via
> +        * tpm_buf_append_u32() instead of tpm_buf_append_name()
> +        */
> +       for (i = 0; i < handles; i++) {
> +               u32 handle = tpm_get_inc_u32(&s);
> +
> +               if (auth->name_h[i] != handle) {
> +                       dev_err(&chip->dev, "TPM: handle %d wrong for name\n",
> +                                 i);
> +                       return;
> +               }
> +       }
> +       /* point s to the start of the sessions */
> +       val = tpm_get_inc_u32(&s);
> +       /* point p to the start of the parameters */
> +       p = s + val;
> +       for (i = 1; s < p; i++) {
> +               u32 handle = tpm_get_inc_u32(&s);
> +               u16 len;
> +               u8 a;
> +
> +               /* nonce (already in auth) */
> +               len = tpm_get_inc_u16(&s);
> +               s += len;
> +
> +               a = *s++;
> +
> +               len = tpm_get_inc_u16(&s);
> +               if (handle == auth->handle && auth->attrs == a) {
> +                       hmac = (u8 *)s;
> +                       /*
> +                        * save our session number so we know which
> +                        * session in the response belongs to us
> +                        */
> +                       auth->session = i;
> +               }
> +
> +               s += len;
> +       }
> +       if (s != p) {
> +               dev_err(&chip->dev, "TPM session length is incorrect\n");
> +               return;
> +       }
> +       if (!hmac) {
> +               dev_err(&chip->dev, "TPM could not find HMAC session\n");
> +               return;
> +       }
> +
> +       /* encrypt before HMAC */
> +       if (auth->attrs & TPM2_SA_DECRYPT) {
> +               struct scatterlist sg[1];
> +               u16 len;
> +               SKCIPHER_REQUEST_ON_STACK(req, auth->aes);
> +
> +               skcipher_request_set_tfm(req, auth->aes);
> +               skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
> +                                             NULL, NULL);
> +

Your crypto_alloc_skcipher() call [further down] does not mask out
CRYPTO_ALG_ASYNC, and so it permits asynchronous implementations to be
selected. Your generic cfb template only permits synchronous
implementations, since it wraps the cipher directly (which is always
synchronous). However, we have support in the tree for some
accelerators that implement cfb(aes), and those will return
-EINPROGRESS when invoking crypto_skcipher_en/decrypt(req), which you
are not set up to handle.

So the simple solution is to call 'crypto_alloc_skcipher("cfb(aes)",
0, CRYPTO_ALG_ASYNC)' below instead.

However, I would prefer it if we permit asynchronous skciphers here.
The reason is that, on a given platform, the accelerator may be the
only truly time invariant AES implementation that is available, and
since we are dealing with the TPM, a bit of paranoia does not hurt. It
also makes it easier to implement it as a [time invariant] SIMD based
asynchronous skcipher, which are simpler than synchronous ones since
they don't require a non-SIMD fallback path for calls from contexts
where the SIMD unit may not be used.

I have already implemented cfb(aes) for arm64/NEON. I will post the
patch after the merge window closes.

> +               /* need key and IV */
> +               KDFa(auth->session_key, SHA256_DIGEST_SIZE
> +                    + auth->passphraselen, "CFB", auth->our_nonce,
> +                    auth->tpm_nonce, AES_KEYBYTES + AES_BLOCK_SIZE,
> +                    auth->scratch);
> +               crypto_skcipher_setkey(auth->aes, auth->scratch, AES_KEYBYTES);
> +               len = tpm_get_inc_u16(&p);
> +               sg_init_one(sg, p, len);
> +               skcipher_request_set_crypt(req, sg, sg, len,
> +                                          auth->scratch + AES_KEYBYTES);
> +               crypto_skcipher_encrypt(req);

So please consider replacing this with something like.

DECLARE_CRYPTO_WAIT(wait); [further up]
skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
                              crypto_req_done, &wait);
crypto_wait_req(crypto_skcipher_encrypt(req), &wait);


> +               /* reset p to beginning of parameters for HMAC */
> +               p -= 2;
> +       }
> +
> +       crypto_shash_init(desc);
> +       /* ordinal is already BE */
> +       crypto_shash_update(desc, (u8 *)&head->ordinal, sizeof(head->ordinal));
> +       /* add the handle names */
> +       for (i = 0; i < handles; i++) {
> +               u8 mso = auth->name_h[i] >> 24;
> +
> +               if (mso == 0x81 || mso == 0x80 || mso == 0x01) {
> +                       crypto_shash_update(desc, auth->name[i],
> +                                           SHA256_DIGEST_SIZE + 2);
> +               } else {
> +                       __be32 h = cpu_to_be32(auth->name_h[i]);
> +
> +                       crypto_shash_update(desc, (u8 *)&h, 4);
> +               }
> +       }
> +       if (buf->data - s != tpm_buf_length(buf))
> +               crypto_shash_update(desc, s, buf->data
> +                                   + tpm_buf_length(buf) - s);
> +       crypto_shash_final(desc, cphash);
> +
> +       /* now calculate the hmac */
> +       hmac_init(desc, auth->session_key, sizeof(auth->session_key)
> +                 + auth->passphraselen);
> +       crypto_shash_update(desc, cphash, sizeof(cphash));
> +       crypto_shash_update(desc, auth->our_nonce, sizeof(auth->our_nonce));
> +       crypto_shash_update(desc, auth->tpm_nonce, sizeof(auth->tpm_nonce));
> +       crypto_shash_update(desc, &auth->attrs, 1);
> +       hmac_final(desc, auth->session_key, sizeof(auth->session_key)
> +                  + auth->passphraselen, hmac);
> +}
> +EXPORT_SYMBOL(tpm_buf_fill_hmac_session);
> +
...
> +/**
> + * tpm_buf_check_hmac_response() - check the TPM return HMAC for correctness
> + * @buf: the original command buffer (which now contains the response)
> + * @auth: the auth structure allocated by tpm2_start_auth_session()
> + * @rc: the return code from tpm_transmit_cmd
> + *
> + * If @rc is non zero, @buf may not contain an actual return, so @rc
> + * is passed through as the return and the session cleaned up and
> + * de-allocated if required (this is required if
> + * TPM2_SA_CONTINUE_SESSION was not specified as a session flag).
> + *
> + * If @rc is zero, the response HMAC is computed against the returned
> + * @buf and matched to the TPM one in the session area.  If there is a
> + * mismatch, an error is logged and -EINVAL returned.
> + *
> + * The reason for this is that the command issue and HMAC check
> + * sequence should look like:
> + *
> + *     rc = tpm_transmit_cmd(...);
> + *     rc = tpm_buf_check_hmac_response(&buf, auth, rc);
> + *     if (rc)
> + *             ...
> + *
> + * Which is easily layered into the current contrl flow.
> + *
> + * Returns: 0 on success or an error.
> + */
> +int tpm_buf_check_hmac_response(struct tpm_buf *buf, struct tpm2_auth *auth,
> +                               int rc)
> +{
> +       struct tpm_output_header *head = (struct tpm_output_header *)buf->data;
> +       struct tpm_chip *chip = auth->chip;
> +       const u8 *s, *p;
> +       u8 rphash[SHA256_DIGEST_SIZE];
> +       u32 attrs;
> +       SHASH_DESC_ON_STACK(desc, sha256_hash);
> +       u16 tag = be16_to_cpu(head->tag);
> +       u32 cc = be32_to_cpu(auth->ordinal);
> +       int parm_len, len, i, handles;
> +
> +       if (auth->session >= TPM_HEADER_SIZE) {
> +               WARN(1, "tpm session not filled correctly\n");
> +               goto out;
> +       }
> +
> +       if (rc != 0)
> +               /* pass non success rc through and close the session */
> +               goto out;
> +
> +       rc = -EINVAL;
> +       if (tag != TPM2_ST_SESSIONS) {
> +               dev_err(&chip->dev, "TPM: HMAC response check has no sessions tag\n");
> +               goto out;
> +       }
> +
> +       i = tpm2_find_cc(chip, cc);
> +       if (i < 0)
> +               goto out;
> +       attrs = chip->cc_attrs_tbl[i];
> +       handles = (attrs >> TPM2_CC_ATTR_RHANDLE) & 1;
> +
> +       /* point to area beyond handles */
> +       s = &buf->data[TPM_HEADER_SIZE + handles * 4];
> +       parm_len = tpm_get_inc_u32(&s);
> +       p = s;
> +       s += parm_len;
> +       /* skip over any sessions before ours */
> +       for (i = 0; i < auth->session - 1; i++) {
> +               len = tpm_get_inc_u16(&s);
> +               s += len + 1;
> +               len = tpm_get_inc_u16(&s);
> +               s += len;
> +       }
> +       /* TPM nonce */
> +       len = tpm_get_inc_u16(&s);
> +       if (s - buf->data + len > tpm_buf_length(buf))
> +               goto out;
> +       if (len != SHA256_DIGEST_SIZE)
> +               goto out;
> +       memcpy(auth->tpm_nonce, s, len);
> +       s += len;
> +       attrs = *s++;
> +       len = tpm_get_inc_u16(&s);
> +       if (s - buf->data + len != tpm_buf_length(buf))
> +               goto out;
> +       if (len != SHA256_DIGEST_SIZE)
> +               goto out;
> +       /*
> +        * s points to the HMAC. now calculate comparison, beginning
> +        * with rphash
> +        */
> +       desc->tfm = sha256_hash;
> +       desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
> +       crypto_shash_init(desc);
> +       /* yes, I know this is now zero, but it's what the standard says */
> +       crypto_shash_update(desc, (u8 *)&head->return_code,
> +                           sizeof(head->return_code));
> +       /* ordinal is already BE */
> +       crypto_shash_update(desc, (u8 *)&auth->ordinal, sizeof(auth->ordinal));
> +       crypto_shash_update(desc, p, parm_len);
> +       crypto_shash_final(desc, rphash);
> +
> +       /* now calculate the hmac */
> +       hmac_init(desc, auth->session_key, sizeof(auth->session_key)
> +                 + auth->passphraselen);
> +       crypto_shash_update(desc, rphash, sizeof(rphash));
> +       crypto_shash_update(desc, auth->tpm_nonce, sizeof(auth->tpm_nonce));
> +       crypto_shash_update(desc, auth->our_nonce, sizeof(auth->our_nonce));
> +       crypto_shash_update(desc, &auth->attrs, 1);
> +       /* we're done with the rphash, so put our idea of the hmac there */
> +       hmac_final(desc, auth->session_key, sizeof(auth->session_key)
> +                  + auth->passphraselen, rphash);
> +       if (memcmp(rphash, s, SHA256_DIGEST_SIZE) == 0) {
> +               rc = 0;
> +       } else {
> +               dev_err(&auth->chip->dev, "TPM: HMAC check failed\n");
> +               goto out;
> +       }
> +
> +       /* now do response decryption */
> +       if (auth->attrs & TPM2_SA_ENCRYPT) {
> +               struct scatterlist sg[1];
> +               SKCIPHER_REQUEST_ON_STACK(req, auth->aes);
> +
> +               skcipher_request_set_tfm(req, auth->aes);
> +               skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
> +                                             NULL, NULL);
> +
> +               /* need key and IV */
> +               KDFa(auth->session_key, SHA256_DIGEST_SIZE
> +                    + auth->passphraselen, "CFB", auth->tpm_nonce,
> +                    auth->our_nonce, AES_KEYBYTES + AES_BLOCK_SIZE,
> +                    auth->scratch);
> +               crypto_skcipher_setkey(auth->aes, auth->scratch, AES_KEYBYTES);
> +               len = tpm_get_inc_u16(&p);
> +               sg_init_one(sg, p, len);
> +               skcipher_request_set_crypt(req, sg, sg, len,
> +                                          auth->scratch + AES_KEYBYTES);
> +               crypto_skcipher_decrypt(req);
> +       }
> +
> + out:
> +       if ((auth->attrs & TPM2_SA_CONTINUE_SESSION) == 0) {
> +               /* manually close the session if it wasn't consumed */
> +               if (rc)
> +                       tpm2_flush_context_cmd(chip, auth->handle, 0);
> +               crypto_free_skcipher(auth->aes);
> +               kfree(auth);
> +       } else {
> +               /* reset for next use  */
> +               auth->session = TPM_HEADER_SIZE;
> +       }
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL(tpm_buf_check_hmac_response);
> +
...
> +/**
> + * tpm2_start_auth_session - create a HMAC authentication session with the TPM
> + * @chip: the TPM chip structure to create the session with
> + * @authp: A pointer to an opaque tpm2_auth structure to be allocated
> + *
> + * This function contacts the TPM via the kernel space for an
> + * authentication session, allocates a tpm2_auth structure to contain
> + * all the session details necessary for performing the HMAC, encrypt
> + * and decrypt operations, fills it in and returns.
> + *
> + * Return: zero on success or actual error encountered.  If return is
> + * zero, @authp will be allocated.
> + */
> +int tpm2_start_auth_session(struct tpm_chip *chip, struct tpm2_auth **authp)
> +{
> +       struct tpm_buf buf;
> +       struct tpm2_auth *auth;
> +       int rc;
> +
> +       auth = kmalloc(sizeof(**authp), GFP_KERNEL);
> +       if (!auth)
> +               return -ENOMEM;
> +
> +       auth->chip = chip;
> +       auth->session = TPM_HEADER_SIZE;
> +
> +       rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_START_AUTH_SESS);
> +       if (rc)
> +               goto out;
> +
> +       /* salt key handle */
> +       tpm_buf_append_u32(&buf, chip->tpmkey);
> +       /* bind key handle */
> +       tpm_buf_append_u32(&buf, TPM2_RH_NULL);
> +       /* nonce caller */
> +       get_random_bytes(auth->our_nonce, sizeof(auth->our_nonce));
> +       tpm_buf_append_u16(&buf, sizeof(auth->our_nonce));
> +       tpm_buf_append(&buf, auth->our_nonce, sizeof(auth->our_nonce));
> +
> +       /* append encrypted salt and squirrel away unencrypted in auth */
> +       tpm_buf_append_salt(&buf, chip, auth);
> +       /* session type (HMAC, audit or policy) */
> +       tpm_buf_append_u8(&buf, TPM2_SE_HMAC);
> +
> +       /* symmetric encryption parameters */
> +       /* symmetric algorithm */
> +       tpm_buf_append_u16(&buf, TPM2_ALG_AES);
> +       /* bits for symmetric algorithm */
> +       tpm_buf_append_u16(&buf, AES_KEYBITS);
> +       /* symmetric algorithm mode (must be CFB) */
> +       tpm_buf_append_u16(&buf, TPM2_ALG_CFB);
> +       /* hash algorithm for session */
> +       tpm_buf_append_u16(&buf, TPM2_ALG_SHA256);
> +
> +       rc = tpm_transmit_cmd(chip, &chip->kernel_space, buf.data, PAGE_SIZE,
> +                             0, 0, "start auth session");
> +       if (rc == TPM2_RC_SUCCESS)
> +               rc = parse_start_auth_session(auth, buf.data);
> +
> +       tpm_buf_destroy(&buf);
> +
> +       if (rc)
> +               goto out;
> +
> +       auth->aes = crypto_alloc_skcipher("cfb(aes)", 0, 0);

^^^

> +       if (IS_ERR(auth->aes)) {
> +               rc = PTR_ERR(auth->aes);
> +               dev_err(&chip->dev, "TPM: error getting cfb(aes): %d\n", rc);
> +       }
> + out:
> +       if (rc)
> +               kfree(auth);
> +       else
> +               *authp = auth;
> +
> +       return rc;
> +}
> +EXPORT_SYMBOL(tpm2_start_auth_session);
> +
