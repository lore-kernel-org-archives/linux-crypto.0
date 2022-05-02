Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC988C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 18:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244668AbiEBS3Y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 14:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386858AbiEBS3T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 14:29:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1746A1AE
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 11:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F5CDB8196F
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 18:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C510C385AC;
        Mon,  2 May 2022 18:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651515946;
        bh=ncTCFSyVR5oNOKxDNDoyId0YCv+2m5GgxZbKB3yRx98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ca81ZNr2MXyjSUqFZt3V5H3ygFJkmdDLzSaY5UmJC+ay8JCRxVjIUBBTCGdjVoVsC
         02LCmZVEGBtsD5R5ps4R5LLcVLIUG95A2R08pKHozuCcC5lOpvlCseqlxEd1UmdZGL
         XmtbhnkWfJPqk6x8F5qeVr2EPNV2gmmgmPOegL0SH8HaY5nQ8BFrm76i2ckDTAZDFF
         ul5HSA21tNDQWo/SHCqdAhEo/l+3bMJafeO9Rwupr9YbuDJqk6rwXwe9zaA36k7uVd
         5Xx/pimakatwjIL0GU2nLh5EQpuYyJT2vo2/p0NfnDCZnm99nL72ZA2u0FCZcBlMEZ
         PdqoFbABoqXnQ==
Date:   Mon, 2 May 2022 11:25:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 3/8] crypto: hctr2 - Add HCTR2 support
Message-ID: <YnAiKL7AvTP3y+LM@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-4-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003759.1115361-4-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 27, 2022 at 12:37:54AM +0000, Nathan Huckleberry wrote:
> +static int hctr2_create_common(struct crypto_template *tmpl,
> +			       struct rtattr **tb,
> +			       const char *xctr_name,
> +			       const char *polyval_name)
> +{
> +	u32 mask;
> +	struct skcipher_instance *inst;
> +	struct hctr2_instance_ctx *ictx;
> +	struct skcipher_alg *xctr_alg;
> +	struct crypto_alg *blockcipher_alg;
> +	struct shash_alg *polyval_alg;
> +	char blockcipher_name[CRYPTO_MAX_ALG_NAME];
> +	int len;
> +	int err;
> +
> +	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
> +	if (err)
> +		return err;
> +
> +	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
> +	if (!inst)
> +		return -ENOMEM;
> +	ictx = skcipher_instance_ctx(inst);
> +
> +	/* Stream cipher, xctr(block_cipher) */
> +	err = crypto_grab_skcipher(&ictx->xctr_spawn,
> +				   skcipher_crypto_instance(inst),
> +				   xctr_name, 0, mask);
> +	if (err)
> +		goto err_free_inst;
> +	xctr_alg = crypto_spawn_skcipher_alg(&ictx->xctr_spawn);
> +
> +	err = -EINVAL;
> +	if (strncmp(xctr_alg->base.cra_name, "xctr(", 5))
> +		goto err_free_inst;
> +	len = strscpy(blockcipher_name, xctr_name + 5,
> +		      sizeof(blockcipher_name));

Found a bug here; 'xctr_name' in the strscpy() statement needs to be
xctr_alg->base.cra_name.  Otherwise something like
'hctr2_base(xctr-aes-aesni,polyval-clmulni)' doesn't work, as it will try to
extract the block cipher name from the driver name "xctr-aes-aesni" instead of
from the algorithm name "xctr(aes)" as intended.

- Eric
