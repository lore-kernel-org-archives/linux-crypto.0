From: Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v2] OMAP: AES: Don't idle/start AES device between Encrypt operations
Date: Tue, 14 May 2013 07:11:09 -0700
Message-ID: <87bo8dy7lu.fsf@linaro.org>
References: <1368500867-7737-1-git-send-email-joelagnel@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: Joel A Fernandes <joelagnel@ti.com>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1368500867-7737-1-git-send-email-joelagnel@ti.com> (Joel
	A. Fernandes's message of "Mon, 13 May 2013 22:07:47 -0500")
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Joel A Fernandes <joelagnel@ti.com> writes:

> Calling runtime PM API for every block causes serious perf hit to
> crypto operations that are done on a long buffer.
> As crypto is performed on a page boundary, encrypting large buffers can
> cause a series of crypto operations divided by page. The runtime PM API
> is also called those many times.
>
> We call runtime_pm_get_sync only at beginning on the session (cra_init)
> and runtime_pm_put at the end. This result in upto a 50% speedup as below.
> This doesn't make the driver to keep the system awake as runtime get/put
> is only called during a crypto session which completes usually quickly.
>
> Before:
> root@beagleboard:~# time -v openssl speed -evp aes-128-cbc
> Doing aes-128-cbc for 3s on 16 size blocks: 13310 aes-128-cbc's in 0.01s
> Doing aes-128-cbc for 3s on 64 size blocks: 13040 aes-128-cbc's in 0.04s
> Doing aes-128-cbc for 3s on 256 size blocks: 9134 aes-128-cbc's in 0.03s
> Doing aes-128-cbc for 3s on 1024 size blocks: 8939 aes-128-cbc's in 0.01s
> Doing aes-128-cbc for 3s on 8192 size blocks: 4299 aes-128-cbc's in 0.00s
>
> After:
> root@beagleboard:~# time -v openssl speed -evp aes-128-cbc
> Doing aes-128-cbc for 3s on 16 size blocks: 18911 aes-128-cbc's in 0.02s
> Doing aes-128-cbc for 3s on 64 size blocks: 18878 aes-128-cbc's in 0.02s
> Doing aes-128-cbc for 3s on 256 size blocks: 11878 aes-128-cbc's in 0.10s
> Doing aes-128-cbc for 3s on 1024 size blocks: 11538 aes-128-cbc's in 0.05s
> Doing aes-128-cbc for 3s on 8192 size blocks: 4857 aes-128-cbc's in 0.03s
>
> While at it, also drop enter and exit pr_debugs, in related code. tracers
> can be used for that.
>
> Tested on a Beaglebone (AM335x SoC) board.
>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>

Acked-by: Kevin Hilman <khilman@linaro.org> 

Thanks for the updated changelog.

Kevin
