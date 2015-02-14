From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: AW: AW: Best way to align key in AES context
Date: Fri, 13 Feb 2015 16:59:28 -0800
Message-ID: <54DE9DF0.3070508@intel.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD863@EXCHANGE.collogia.de> <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DD877@EXCHANGE.collogia.de>,<54DE0E6F.7090509@intel.com> <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DE3DA@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Markus Stockhausen <stockhausen@collogia.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:8945 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbbBNBDK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Feb 2015 20:03:10 -0500
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9DE3DA@EXCHANGE.collogia.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/13/2015 08:49 AM, Markus Stockhausen wrote:
> thanks for the tip.  I will at least move the data definitions to the beginning of 
> my structure.
> 
> But while it sounds logical for data types that are directly created from that 
> structure I'm unsure about a context. If I understand it correctly a context is 
> dynamically allocated. Could it be possible that the start address is then only 
> 4 bytes aligned?
> 
> So I tried to dive into the magic of alignmask and contexts. This even confuses
> me a little bit more. Nearly all implementations in the crypto tree make use of
> alignmasks >= 3. I guess to be at least 4 bytes aligned. But when accessing the
> context they "only" use crypto_blkcipher_ctx(). This will just return the context
> address while crypto_blkcipher_ctx_aligned() seems to be the right place to 
> return a pointer that is aligned according to the predefined mask.
> 
> Would you recommend to
> 
> a) ignore alignmask and use only __aligned(8) for the structure
> 
> b) to assume ctx will be automatically 8 bytes aligned regardless of __aligned(8)
> flag or cra_alignmask. So nothing to take care about.
> 
> b) or to define structure without __aligned(8) but work with cra_alignmask=7. 
> I fear that this might impose alignment of input/output data to 8 too and lead 
> to unneccessary memcpy() operations.
> 
> Sorry for driving myself nuts but I want to understand if before I send patches.

In this case I think the best way is to define your algorithm with

	.cra_ctxsize = sizeof(struct ppc_aes_ctx) + 8,

and then in enc/dec/setkey do

	struct ppc_aes_ctx *ctx = PTR_ALIGN(crypto_tfm_ctx(tfm), 8);

and you don't need the __aligned(8) in the struct definition.
