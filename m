From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging:ccree Fix avoid externs in .c files
Date: Sun, 24 Sep 2017 10:23:28 +0300
Message-ID: <CAOtvUMdYiY07R0eWg7wJo5bD2MgkchZmxnYB=anfYp7cvJta9g@mail.gmail.com>
References: <1505976197-28467-1-git-send-email-jananis37@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Janani Sankara Babu <jananis37@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1505976197-28467-1-git-send-email-jananis37@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 21, 2017 at 9:43 AM, Janani Sankara Babu
<jananis37@gmail.com> wrote:
> This patch solves the warning shown by the checkpatch script
> WARNING: externs should be avoided in .c files

I'm afraid here too the feedback is the same - you are working on the
Linus master tree, therefore you are seeing
things that are already gone from the downstream staging tree.


Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
