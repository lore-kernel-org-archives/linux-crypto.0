Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A1ECE7A89
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Sep 2023 08:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjIWI4U (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Sep 2023 04:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjIWI4T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Sep 2023 04:56:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87423136;
        Sat, 23 Sep 2023 01:56:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B6FC433C7;
        Sat, 23 Sep 2023 08:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695459373;
        bh=0U26ntWWWFIg9iV7YhYP9NzZfC/c3SeOSlemUAkII4I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KN0LThsonm6ev8X5HK1VCOu9PghLnTEGQACvsLC9BLA6ODKw56fxftZeBu6OAJ/Vy
         bQ53dAApTT1MCt7uAHY4ZLtjyX4HSKoT1SD3BcO8cB91zRSZ+TbguIVoxOj5L6qdnW
         NIikI0eJCmxwt3RCGH49+DPOb/xYJDMU7KN9ZdIUhyBabdoeKtLalUZKAsIQEem8QV
         OKRuHwz4t+QUTD3ceDxPl2YSL2AnAxll2cSYOHB/C5X/kYo+bxPDVdpBRXB6WLN9Bj
         bjTA8s5hvWXN8COr9p/7jSCUlmP62NlVQjXkmspA6eFTc6fkkKa0wqsFNIjWvpRCkJ
         QEU69h62MHCEA==
Date:   Sat, 23 Sep 2023 10:57:14 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Adam Guerin <adam.guerin@intel.com>,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: qat: Annotate struct adf_fw_counters with
 __counted_by
Message-ID: <ZQ8Y6hGl1xiP9I69@work>
References: <20230922175432.work.709-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922175432.work.709-kees@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 22, 2023 at 10:54:33AM -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct adf_fw_counters.
> 
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
> 
> Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Tom Rix <trix@redhat.com>
> Cc: Adam Guerin <adam.guerin@intel.com>
> Cc: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: qat-linux@intel.com
> Cc: linux-crypto@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>  drivers/crypto/intel/qat/qat_common/adf_fw_counters.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
> index cb6e09ef5c9f..6abe4736eab8 100644
> --- a/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
> +++ b/drivers/crypto/intel/qat/qat_common/adf_fw_counters.c
> @@ -34,7 +34,7 @@ struct adf_ae_counters {
>  
>  struct adf_fw_counters {
>  	u16 ae_count;
> -	struct adf_ae_counters ae_counters[];
> +	struct adf_ae_counters ae_counters[] __counted_by(ae_count);
>  };
>  
>  static void adf_fw_counters_parse_ae_values(struct adf_ae_counters *ae_counters, u32 ae,
> -- 
> 2.34.1
> 
> 
