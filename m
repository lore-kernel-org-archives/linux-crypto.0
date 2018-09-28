From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mxs-dcp - Fix wait logic on chan threads
Date: Fri, 28 Sep 2018 13:10:08 +0800
Message-ID: <20180928051007.53pokj4jmazcdikz@gondor.apana.org.au>
References: <163d1af7d51bfa330f4cc685c5c493cd38aa584b.1537541211.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marek Vasut <marek.vasut@gmail.com>,
        "David S . Miller " <davem@davemloft.net>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, linux-crypto@vger.kernel.org,
        linux-imx@nxp.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org
To: Leonard Crestez <leonard.crestez@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <163d1af7d51bfa330f4cc685c5c493cd38aa584b.1537541211.git.leonard.crestez@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 21, 2018 at 06:03:18PM +0300, Leonard Crestez wrote:
> When compiling with CONFIG_DEBUG_ATOMIC_SLEEP=y the mxs-dcp driver
> prints warnings such as:
> 
> WARNING: CPU: 0 PID: 120 at kernel/sched/core.c:7736 __might_sleep+0x98/0x9c
> do not call blocking ops when !TASK_RUNNING; state=1 set at [<8081978c>] dcp_chan_thread_sha+0x3c/0x2ec
> 
> The problem is that blocking ops will manipulate current->state
> themselves so it is not allowed to call them between
> set_current_state(TASK_INTERRUPTIBLE) and schedule().
> 
> Fix this by converting the per-chan mutex to a spinlock (it only
> protects tiny list ops anyway) and rearranging the wait logic so that
> callbacks are called current->state as TASK_RUNNING. Those callbacks
> will indeed call blocking ops themselves so this is required.
> 
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
