From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [CRYPTO] cast6: inline bloat--
Date: Sat, 12 Jan 2008 03:47:41 +0100
Message-ID: <20080112024741.GA27661@one.firstfloor.org>
References: <Pine.LNX.4.64.0801071535300.31652@kivilampi-30.cs.helsinki.fi> <p73ve62nzzk.fsf@bingen.suse.de> <Pine.LNX.4.64.0801101114070.1408@kivilampi-30.cs.helsinki.fi> <20080110092555.GB25076@one.firstfloor.org> <20080110092746.GA11613@gondor.apana.org.au> <20080110133529.GA13851@Chamillionaire.breakpoint.cc> <20080110154650.GA29453@one.firstfloor.org> <20080112000937.GA23721@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Andi Kleen <andi@firstfloor.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:56217 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbYALCo6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2008 21:44:58 -0500
Content-Disposition: inline
In-Reply-To: <20080112000937.GA23721@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> The inline and not inline performance is quite similar. I guess the
> little difference here and there is due to some random ctx switches (I

Are you sure you were not just IO bound? It would have been better
to test in memory (e.g. using ramfs or just some direct test client)

-Andi
