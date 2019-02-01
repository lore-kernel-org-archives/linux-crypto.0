Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BE0C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AFB820857
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbfBAG1Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:27:25 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:56740 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbfBAG1Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:27:25 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSI8-0008Kg-27; Fri, 01 Feb 2019 14:27:08 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSHw-00053z-00; Fri, 01 Feb 2019 14:26:56 +0800
Date:   Fri, 1 Feb 2019 14:26:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, qat-linux@intel.com
Subject: Re: [RFC PATCH v4] akcipher: new verify API for public key algorithms
Message-ID: <20190201062655.hmxeqo5hprhcgtfx@gondor.apana.org.au>
References: <20190125180116.13702-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125180116.13702-1-vt@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 25, 2019 at 09:01:16PM +0300, Vitaly Chikunov wrote:
>
> @@ -781,36 +780,17 @@ static int tpm_key_verify_signature(const struct key *key,
>  	if (!req)
>  		goto error_free_tfm;
>  
> -	ret = -ENOMEM;
> -	outlen = crypto_akcipher_maxsize(tfm);
> -	output = kmalloc(outlen, GFP_KERNEL);
> -	if (!output)
> -		goto error_free_req;
> -
> -	sg_init_one(&sig_sg, sig->s, sig->s_size);
> -	sg_init_one(&digest_sg, output, outlen);
> -	akcipher_request_set_crypt(req, &sig_sg, &digest_sg, sig->s_size,
> -				   outlen);
> +	sg_init_table(&src_sg, 2);
> +	sg_set_buf(&src_sg[0], sig->s, sig->s_size);
> +	sg_set_buf(&src_sg[1], sig->digest, sig->digest_size);
> +	akcipher_request_set_crypt(req, &src_sg, NULL, sig->s_size,
> +				   sig->digest_size);

It's not clear that sig->digest is guaranteed to be kmalloc memory.
In any case, it's best not to mix unrelated changes in a single
patch.  So please keep the kmalloc on output and then copy
sig->digest into it and put output into the SG list.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
