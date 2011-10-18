From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH v2.1 4/7] crypto: GnuPG based MPI lib - additional sources
 (part 4)
Date: Tue, 18 Oct 2011 17:46:57 +1100 (EST)
Message-ID: <alpine.LRH.2.00.1110181746420.8899@tundra.namei.org>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com> <81f834dca8feb889e2acbc666e730cf89b5d5c41.1318598705.git.dmitry.kasatkin@intel.com> <alpine.LRH.2.00.1110151132430.24994@tundra.namei.org>
 <CALLzPKbdM3Q3i-wuqqemMQzP9AWGnVki7SOAmRu9z-u0o8uGkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	herbert@gondor.hengli.com.au
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:57525 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab1JRGtK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 02:49:10 -0400
In-Reply-To: <CALLzPKbdM3Q3i-wuqqemMQzP9AWGnVki7SOAmRu9z-u0o8uGkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 17 Oct 2011, Kasatkin, Dmitry wrote:

> It is there for completeness and it will not be even compiled at all
> without CONFIG_MPILIB_EXTRA
> 
> Still remove?

Yes, please.


-- 
James Morris
<jmorris@namei.org>
