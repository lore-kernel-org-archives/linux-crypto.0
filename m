From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 1/1] Fix coding style of driver/staging/ccree/ssi_aead.c
Date: Sun, 18 Jun 2017 08:52:28 +0300
Message-ID: <CAOtvUMe0KjwGXf5=aoBtG562t0uTMxpE7NiSUBSD+UaUGa-n_w@mail.gmail.com>
References: <20170616134842.GA3882@jm-toshiba>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Jhih-Ming Hunag <fbihjmeric@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170616134842.GA3882@jm-toshiba>
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

Hello Jhin-Ming,

Thank your for your patch!

On Fri, Jun 16, 2017 at 4:48 PM, Jhih-Ming Hunag <fbihjmeric@gmail.com> wrote:
> I fix some coding style errors/warnings of drivers/staging/ccree/ssi_aead.c.
> From
> total: 54 errors, 109 warnings, 2769 lines checked
> to
> total: 0 errors, 69 warnings, 2766 lines checked
>
> All of remaining warning are 'WARNING: line over 80 characters'.
> I think those can be accepted for readability.
>
> I am new to send kernel patch.
> If I did something wrong, please kindly tell me.

Unfortunately, in order to properly be able to review patches, one patch
must only fix or change a single thing a time.

For example, I've noticed your patch fixes many cases of wrong placement of
curly brackets in the code. If the patch would ONLY fix this error where ever it
is it would be fine!

However, your patch also fixes other style errors at the same time, making it
difficult to review, so unfortunately it has to be rejected as it is now.

Please feel free to send a series of patches each fixing a different style error
instead.

Thanks,
Gilad



> Thanks
>


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
