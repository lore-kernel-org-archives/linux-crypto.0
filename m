Return-Path: <SRS0=qsSA=CV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32EAC433E2
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Sep 2020 08:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC60214F1
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Sep 2020 08:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgILIg5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Sep 2020 04:36:57 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:57326 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgILIg5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Sep 2020 04:36:57 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 8C4D172CA54;
        Sat, 12 Sep 2020 11:36:52 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 40EEF4A4A16;
        Sat, 12 Sep 2020 11:36:52 +0300 (MSK)
Date:   Sat, 12 Sep 2020 11:36:52 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephan Mueller <smueller@chronox.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Waiman Long <longman@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Colin Ian King <colin.king@canonical.com>,
        Tushar Sugandhi <tusharsu@linux.microsoft.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Pascal van Leeuwen <pvanleeuwen@rambus.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-security-module@vger.kernel.org,
        Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Subject: Re: [PATCH v6 8/8] integrity: Asymmetric digsig supports
 SM2-with-SM3 algorithm
Message-ID: <20200912083652.dxosjsartbvnxq2r@altlinux.org>
References: <20200903131242.128665-1-tianjia.zhang@linux.alibaba.com>
 <20200903131242.128665-9-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20200903131242.128665-9-tianjia.zhang@linux.alibaba.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 03, 2020 at 09:12:42PM +0800, Tianjia Zhang wrote:
> Asymmetric digsig supports SM2-with-SM3 algorithm combination,
> so that IMA can also verify SM2's signature data.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Tested-by: Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>
> Reviewed-by: Mimi Zohar <zohar@linux.ibm.com> (coding, not crypto

It looks not breaking ecrdsa/streebog handling and accords to rfc draft:

  https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02

  5.1.4.2.  Hash Functions
    The sm2 digital signature algorithm requires the hash functions
    approved by Chinese Commercial Cryptography Administration Office,
    such as sm3.

Reviewed-by: Vitaly Chikunov <vt@altlinux.org>

Thanks,

> ---
>  security/integrity/digsig_asymmetric.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
> index cfa4127d0518..b86a4a8f61ab 100644
> --- a/security/integrity/digsig_asymmetric.c
> +++ b/security/integrity/digsig_asymmetric.c
> @@ -99,14 +99,22 @@ int asymmetric_verify(struct key *keyring, const char *sig,
>  	memset(&pks, 0, sizeof(pks));
>  
>  	pks.hash_algo = hash_algo_name[hdr->hash_algo];
> -	if (hdr->hash_algo == HASH_ALGO_STREEBOG_256 ||
> -	    hdr->hash_algo == HASH_ALGO_STREEBOG_512) {
> +	switch (hdr->hash_algo) {
> +	case HASH_ALGO_STREEBOG_256:
> +	case HASH_ALGO_STREEBOG_512:
>  		/* EC-RDSA and Streebog should go together. */
>  		pks.pkey_algo = "ecrdsa";
>  		pks.encoding = "raw";
> -	} else {
> +		break;
> +	case HASH_ALGO_SM3_256:
> +		/* SM2 and SM3 should go together. */
> +		pks.pkey_algo = "sm2";
> +		pks.encoding = "raw";
> +		break;
> +	default:
>  		pks.pkey_algo = "rsa";
>  		pks.encoding = "pkcs1";
> +		break;
>  	}
>  	pks.digest = (u8 *)data;
>  	pks.digest_size = datalen;
