From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] crypto: mxs-dcp - Fix wait logic on chan threads
Date: Fri, 21 Sep 2018 14:47:15 -0300
Message-ID: <CAOMZO5CpXjoh0r+HXY7UWCrusbqL-F+oKU1iKKvJ_sLfHhdq+w@mail.gmail.com>
References: <163d1af7d51bfa330f4cc685c5c493cd38aa584b.1537541211.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, NXP Linux Team <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Leonard Crestez <leonard.crestez@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <163d1af7d51bfa330f4cc685c5c493cd38aa584b.1537541211.git.leonard.crestez@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Leonard,

On Fri, Sep 21, 2018 at 12:03 PM, Leonard Crestez
<leonard.crestez@nxp.com> wrote:
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

Do you have extra patches to allow this driver to probe?

I see the following probe error for a long time with mainline:

[   25.611780] mxs-dcp 80028000.dcp: Failed to register sha1 hash!
[   25.620798] mxs-dcp: probe of 80028000.dcp failed with error -22

Do you have a fix for this?

Thanks
