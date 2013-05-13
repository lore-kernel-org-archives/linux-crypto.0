From: Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH] OMAP: AES: Don't idle/start AES device between Encrypt operations
Date: Mon, 13 May 2013 09:35:49 -0700
Message-ID: <878v3i6dne.fsf@linaro.org>
References: <1368293024-6654-1-git-send-email-joelagnel@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	"Mark A. Greer" <mgreer@animalcreek.com>
To: Joel A Fernandes <joelagnel@ti.com>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <1368293024-6654-1-git-send-email-joelagnel@ti.com> (Joel
	A. Fernandes's message of "Sat, 11 May 2013 12:23:44 -0500")
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Joel A Fernandes <joelagnel@ti.com> writes:

> Calling runtime PM API for every block causes serious perf hit to
> crypto operations that are done on a long buffer.
> As crypto is performed on a page boundary, encrypting large buffers can
> cause a series of crypto operations divided by page. The runtime PM API
> is also called those many times.
>
> We call runtime_pm_get_sync only at beginning of the session (cra_init)
> and runtime_pm_put at the end. This result in upto a 50% speedup as below:
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
> are exactly used for that.
>
> Tested on a Beaglebone (AM335x SoC) board.
>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>

Did you explore using runtime PM autosuspend timeouts for this instead?
They are intended for exactly this kind of thing, and the timeouts can
have sane defaults, but can be configured from userspace to allow a
power/performance trade-off.

[...]

>  static void omap_aes_cra_exit(struct crypto_tfm *tfm)
>  {
> -	pr_debug("enter\n");
> +	struct omap_aes_dev *dd = NULL;
> +
> +	/* Find AES device, currently picks the first device */
> +	spin_lock_bh(&list_lock);
> +	list_for_each_entry(dd, &dev_list, list) {
> +		break;
> +	}
> +	spin_unlock_bh(&list_lock);
> +
> +	pm_runtime_put_sync(dd->dev);

nit: Why use the synchronous call here?  The original was async.

Kevin
