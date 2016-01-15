From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/2] n2rng: Attach on T5/M5, T7/M7 SPARC CPUs
Date: Fri, 15 Jan 2016 15:22:53 -0500 (EST)
Message-ID: <20160115.152253.1613974535141140248.davem@davemloft.net>
References: <20160113214318.GB32766@yogzotot>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org,
	herbert@gondor.apana.org.au
To: matorola@gmail.com
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20160113214318.GB32766@yogzotot>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Anatoly Pugachev <matorola@gmail.com>
Date: Thu, 14 Jan 2016 00:43:18 +0300

> This patch adds support for recent oracle hardware (T5/M5, T7/M7 SPARC CPUs),
> so n2_rng driver would work on them.
> 
> 1. n2rng: Attach on T5/M5, T7/M7 SPARC CPUs
> 2. n2rng: documentation, add DT bindings, vendor prefixes
> 
> PS: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=809815#32
> 
> Signed-off-by: Anatoly Pugachev <matorola@gmail.com>

This series looks fine:

Acked-by: David S. Miller <davem@davemloft.net>

Herbert, please take this via your crypto tree.

Thanks!
