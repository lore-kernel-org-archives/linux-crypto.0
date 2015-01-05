From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: qat - Fix incorrect uses of memzero_explicit
Date: Mon, 05 Jan 2015 09:49:05 -0800
Message-ID: <54AACE91.7070904@intel.com>
References: <20150105054813.GA23110@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: qat-linux <qat-linux@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37417 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbbAERwU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 12:52:20 -0500
In-Reply-To: <20150105054813.GA23110@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/04/2015 09:48 PM, Herbert Xu wrote:
> memzero_explicit should only be used on stack variables that get
> zapped just before they go out of scope.
> 
> This patch replaces all unnecessary uses of memzero_explicit with
> memset, removes two memzero_explicit calls altogether as the tfm
> context comes pre-zeroed, and adds a missing memzero_explicit of
> the stack variable buff in qat_alg_do_precomputes.  The memzeros
> on ipad/opad + digest_size/auth_keylen are also removed as the
> entire auth_state is already zeroed on entry.

Hi Herbert,
Except the bad indentation in lines 1176 & 1183 :) this looks ok to me.
Thanks.

Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>
