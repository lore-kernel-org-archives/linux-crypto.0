From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [crypto] fix writting into unallocated memory in setkey_aligned
Date: Thu, 2 Aug 2007 14:59:17 +0200
Message-ID: <20070802125917.GD24639@Chamillionaire.breakpoint.cc>
References: <20070802125743.GC24639@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56585 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbXHBM7R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2007 08:59:17 -0400
Content-Disposition: inline
In-Reply-To: <20070802125743.GC24639@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Sebastian Siewior | 2007-08-02 14:57:43 [+0200]:

>setkey_unaligned() commited in ca7c39385ce1a7b44894a4b225a4608624e90730
>overwrites unallocated memory in the following memset() because I used the
>wrong buffer length.

Herbert, I am really sorry for introducing new bugs.

Sebastian
