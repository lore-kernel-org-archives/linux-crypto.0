Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9662C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 994D52395C
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbhANGnT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 01:43:19 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42142 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725888AbhANGnT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 01:43:19 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kzwKz-00085m-4G; Thu, 14 Jan 2021 17:42:30 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Jan 2021 17:42:28 +1100
Date:   Thu, 14 Jan 2021 17:42:28 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        pathreya@marvell.com, jerinj@marvell.com,
        Suheil Chandran <schandran@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>
Subject: Re: [PATCH 4/9] crypto: octeontx2: load microcode and create engine
 groups
Message-ID: <20210114064228.GA3411@gondor.apana.org.au>
References: <20210106104223.6182-1-schalla@marvell.com>
 <20210106104223.6182-5-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106104223.6182-5-schalla@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 06, 2021 at 04:12:18PM +0530, Srujana Challa wrote:
>
> +static int cpt_ucode_load_fw(struct pci_dev *pdev, struct fw_info_t *fw_info)
> +{
> +	char filename[OTX2_CPT_NAME_LENGTH];
> +	char eng_type[8] = {0};
> +	int ret, e, i;
> +
> +	INIT_LIST_HEAD(&fw_info->ucodes);
> +
> +	for (e = 1; e < OTX2_CPT_MAX_ENG_TYPES; e++) {
> +		strncpy(eng_type, get_eng_type_str(e), 2);

This triggers a compiler warning:

../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c: In function ‘cpt_ucode_load_fw’:
../drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c:408:3: warning: ‘strncpy’ output may be truncated copying 2 bytes from a string of length 2 [-Wstringop-truncation]
   strncpy(eng_type, get_eng_type_str(e), 2);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please fix.  Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
