From: Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH 6/6] workqueue: reimplement WQ_HIGHPRI using a separate worker_pool
Date: Thu, 12 Jul 2012 16:46:12 -0700
Message-ID: <CA+8MBbJbjKmH29Yapih9anxXTsNy7C2TWgtnFX3-Gm6cNyCY3g@mail.gmail.com>
References: <1341859315-17759-7-git-send-email-tj@kernel.org>
	<20120712130648.GA19214@localhost>
	<20120712170519.GA20167@google.com>
	<20120712214514.GD20167@google.com>
	<CA+8MBb+ghRpmtrk=t5-6MqrPMZt+a69UoAWaubyKBeptGdBrWA@mail.gmail.com>
	<20120712223221.GF20167@google.com>
	<CA+8MBbJQVF3-CUU8MPWgm7OifD-C8=U2=uPF3JH9XNvAWVAX6A@mail.gmail.com>
	<20120712233645.GG20167@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
	vgoyal@redhat.com, vwadekar@nvidia.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, swhiteho@redhat.com, bpm@sgi.com,
	elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
	gustavo@padovan.org, johan.hedberg@gmail.com,
	linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120712233645.GG20167@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 12, 2012 at 4:36 PM, Tejun Heo <tj@kernel.org> wrote:
> The debug patch didn't do anything for the bug itself.  I suppose it's
> timing dependent and doesn't always happen (it never reproduces here
> for some reason).  Can you please repeat several times and see whether
> the warning can be triggered?

Still hasn't come back in three reboots.  I have to leave now, can continue
tomorrow.

-Tony
