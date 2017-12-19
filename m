From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: n2 - cure use after free
Date: Tue, 19 Dec 2017 13:39:13 -0500 (EST)
Message-ID: <20171219.133913.989258584455045384.davem@davemloft.net>
References: <20171219.113820.1629794046915223777.davem@davemloft.net>
        <20171219180907.12895-1-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org, linux-crypto@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk
To: jengelh@inai.de
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20171219180907.12895-1-jengelh@inai.de>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Jan Engelhardt <jengelh@inai.de>
Date: Tue, 19 Dec 2017 19:09:07 +0100

> queue_cache_init is first called for the Control Word Queue
> (n2_crypto_probe). At that time, queue_cache[0] is NULL and a new
> kmem_cache will be allocated. If the subsequent n2_register_algs call
> fails, the kmem_cache will be released in queue_cache_destroy, but
> queue_cache_init[0] is not set back to NULL.
> 
> So when the Module Arithmetic Unit gets probed next (n2_mau_probe),
> queue_cache_init will not allocate a kmem_cache again, but leave it
> as its bogus value, causing a BUG() to trigger when queue_cache[0] is
> eventually passed to kmem_cache_zalloc:
 ...
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>

Acked-by: David S. Miller <davem@davemloft.net>
