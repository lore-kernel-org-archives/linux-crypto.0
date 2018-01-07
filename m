From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging: ccree: shorten lengthy lines with breaks
Date: Sun, 7 Jan 2018 14:12:51 +0200
Message-ID: <CAOtvUMdp+UrFAy=bvdJXf5gd_nOhWBCwiVsTz_DyJ56vY_9EPw@mail.gmail.com>
References: <20180106154726.10465-1-gebulmer@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Joe Perches <joe@perches.com>
To: George Edward Bulmer <gebulmer@googlemail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180106154726.10465-1-gebulmer@googlemail.com>
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

Hi George,

On Sat, Jan 6, 2018 at 5:47 PM, George Edward Bulmer
<gebulmer@googlemail.com> wrote:
> This fixes five instances of checkpatch warning:
> WARNING: line over 80 characters
>

Thank you for the patch.


> Signed-off-by: George Edward Bulmer <gebulmer@googlemail.com>
> ---
>  drivers/staging/ccree/ssi_sysfs.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)

Unfortunately, I believe you are not working with the latest
staging-next tree as
this issue and indeed the file it appears in are not longer there.

Many thanks,
Gilad
