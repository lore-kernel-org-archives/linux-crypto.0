From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Thu, 10 Jan 2008 11:17:10 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi>
 <p73ve62nzzk.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696243703-1608343329-1199956630=:1408"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39246 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYAJJRM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Jan 2008 04:17:12 -0500
In-Reply-To: <p73ve62nzzk.fsf@bingen.suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-1608343329-1199956630=:1408
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 10 Jan 2008, Andi Kleen wrote:

> "Ilpo Järvinen" <ilpo.jarvinen@helsinki.fi> writes:
> 
> > Bloat-o-meter shows rather high readings for cast6...
> 
> Have you measured if the performance doesn't suffer from that
> change? Inner loops of ciphers tend to be quite performance
> sensitive and the inlines might actually help a lot. 

No, I haven't measured.


-- 
 i.
---696243703-1608343329-1199956630=:1408--
