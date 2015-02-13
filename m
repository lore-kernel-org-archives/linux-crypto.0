From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: AW: Best way to align key in AES context
Date: Fri, 13 Feb 2015 06:47:11 -0800
Message-ID: <54DE0E6F.7090509@intel.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD863@EXCHANGE.collogia.de> <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD877@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Markus Stockhausen <stockhausen@collogia.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15270 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbbBMOuw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Feb 2015 09:50:52 -0500
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD877@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/11/2015 02:28 AM, Markus Stockhausen wrote:
> I want to ensure that the key data in an AES ctx structure is 8 byte aligned
> to avoid aligment exceptions afterwards. Other fields don't need that
> restriction. At the moment I'm using the following (ugly) implementation.
> 
> struct ppc_aes_ctx {
>         u32 rounds;
>         u32 *key_enc;
>         u32 *key_dec;
>         char data[AES_MAX_KEYLENGTH * 2 + 8];
> };
> ...
> char *ptr;
> ptr = ctx->data;
> ptr = PTR_ALIGN(ptr, 8);
> ctx->key_enc = (u32 *)(ptr);
> ctx->key_dec = (u32 *)(ptr + AES_MAX_KEYLENGTH);
> 
> Can anyone show me the recommended way for doing that.


You can use gcc attributes.

struct ppc_aes_ctx {
        u8 key_enc[AES_MAX_KEYLENGTH];
        u8 key_dec[AES_MAX_KEYLENGTH];
        u32 rounds;
} __aligned(8);
