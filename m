From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [RFC PATCH v2 4/4] crypto: testmgr - add genkey kpp test
Date: Fri, 26 May 2017 16:44:26 +0300
Message-ID: <5be85917-79d3-9ad8-5292-be1d5a448719@microchip.com>
References: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com>
 <1495034813-27143-5-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <marcel@holtmann.org>, <Nicolas.Ferre@microchip.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:62289 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdEZNoc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2017 09:44:32 -0400
In-Reply-To: <1495034813-27143-5-git-send-email-tudor.ambarus@microchip.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 17.05.2017 18:26, Tudor Ambarus wrote:
> The test considers a party that already has a private-public
> key pair and a party that provides a NULL key. The kernel will
> generate the private-public key pair for the latter, computes
> the shared secret on both ends and verifies it it's the same.
> 
> The explicit private-public key pairs were copied from
> the previous test vectors.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>   crypto/testmgr.c |  76 +++++++++++++++++++++++----
>   crypto/testmgr.h | 155 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 220 insertions(+), 11 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 6f5f3ed..faf5fd8 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -1997,6 +1997,9 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
>   	struct kpp_request *req;
>   	void *input_buf = NULL;
>   	void *output_buf = NULL;
> +	void *a_public = NULL;
> +	void *a_ss = NULL;
> +	void *shared_secret = NULL;
>   	struct tcrypt_result result;
>   	unsigned int out_len_max;
>   	int err = -ENOMEM;
> @@ -2026,20 +2029,31 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
>   	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>   				 tcrypt_complete, &result);
>   
> -	/* Compute public key */
> +	/* Compute party A's public key */
>   	err = wait_async_op(&result, crypto_kpp_generate_public_key(req));
>   	if (err) {
> -		pr_err("alg: %s: generate public key test failed. err %d\n",
> +		pr_err("alg: %s: Party A: generate public key test failed. err %d\n",
>   		       alg, err);
>   		goto free_output;
>   	}
> -	/* Verify calculated public key */
> -	if (memcmp(vec->expected_a_public, sg_virt(req->dst),
> -		   vec->expected_a_public_size)) {
> -		pr_err("alg: %s: generate public key test failed. Invalid output\n",
> -		       alg);
> -		err = -EINVAL;
> -		goto free_output;
> +
> +	if (vec->genkey) {
> +		/* Save party A's public key */
> +		a_public = kzalloc(out_len_max, GFP_KERNEL);
> +		if (!a_public) {
> +			err = -ENOMEM;
> +			goto free_output;
> +		}
> +		memcpy(a_public, sg_virt(req->dst), sizeof(*a_public));

The size is wrong, I'll correct it in the next version.
