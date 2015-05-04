From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 crypto-2.6] lib: make memzero_explicit more robust
 against dead store elimination
Date: Mon, 4 May 2015 17:56:03 +0800
Message-ID: <20150504095603.GA30092@gondor.apana.org.au>
References: <130433ffe7d52c43c7e2804db424e07f4a64a7eb.1430359793.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	mancha security <mancha1@zoho.com>,
	Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60044 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbbEDJ4O (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 May 2015 05:56:14 -0400
Content-Disposition: inline
In-Reply-To: <130433ffe7d52c43c7e2804db424e07f4a64a7eb.1430359793.git.daniel@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 30, 2015 at 04:13:52AM +0200, Daniel Borkmann wrote:
> In commit 0b053c951829 ("lib: memzero_explicit: use barrier instead
> of OPTIMIZER_HIDE_VAR"), we made memzero_explicit() more robust in
> case LTO would decide to inline memzero_explicit() and eventually
> find out it could be elimiated as dead store.

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
