From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH RFC 3/3] crypto: tools: Add cryptostat userspace
Date: Wed, 20 Dec 2017 15:37:24 -0800
Message-ID: <167f88c3-a70e-57f4-6715-129d40d1e4a9@infradead.org>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
 <1513800567-12764-4-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52102 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755928AbdLTXh0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 18:37:26 -0500
In-Reply-To: <1513800567-12764-4-git-send-email-clabbe@baylibre.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/20/2017 12:09 PM, Corentin Labbe wrote:
> Add an example tool for getting easily crypto statistics.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  tools/crypto/cryptostat | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100755 tools/crypto/cryptostat
> 
> diff --git a/tools/crypto/cryptostat b/tools/crypto/cryptostat
> new file mode 100755
> index 000000000000..314e108eb608
> --- /dev/null
> +++ b/tools/crypto/cryptostat
> @@ -0,0 +1,40 @@
> +#!/bin/bash
> +
> +for dn in `ls /sys/kernel/crypto/`
> +do
> +	dnpath=/sys/kernel/crypto/$dn/
> +	algtype=$(cat $dnpath/algtype)
> +	algname=$(cat $dnpath/algname)
> +	echo "$dn ($algtype) $algname"
> +	case $algtype in
> +	hash)
> +	echo -e "\tHash: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
> +	;;
> +	cipher)
> +	echo -e "\tEncrypt: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
> +	echo -e "\tDecrypt: $(cat $dnpath/dec_cnt)\tbytes $(cat $dnpath/dec_tlen)"
> +	;;
> +	compress)
> +	echo -e "\tCompress: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
> +	echo -e "\tDecompress: $(cat $dnpath/dec_cnt)\tbytes $(cat $dnpath/dec_tlen)"
> +	;;
> +	asymetric)

spello:
	asymmetric)

> +	echo -e "\tEncrypt: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
> +	echo -e "\tDecrypt: $(cat $dnpath/dec_cnt)\tbytes $(cat $dnpath/dec_tlen)"
> +	echo -e "\tVerify: $(cat $dnpath/verify_cnt)"
> +	echo -e "\tSign: $(cat $dnpath/sign_cnt)"
> +	;;
> +	rng)
> +	echo -e "\tGenerate: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
> +	echo -e "\tSeed: $(cat $dnpath/dec_cnt)"
> +	;;
> +	kpp)
> +	echo -e "\tSet_secret: $(cat $dnpath/dec_cnt)"
> +	echo -e "\tGenerate_public_key: $(cat $dnpath/enc_cnt)"
> +	echo -e "\tCompute_shared_secret: $(cat $dnpath/verify_cnt)"
> +	;;
> +	*)
> +	echo -e "\t$(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
> +	;;
> +	esac
> +done
> 


-- 
~Randy
