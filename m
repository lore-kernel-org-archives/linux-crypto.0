From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging:ccree Fix use BIT macro
Date: Sun, 24 Sep 2017 10:20:28 +0300
Message-ID: <CAOtvUMcHOwE0Tc86wy=AGTwj_K+shJk_UZmZ51iahMV5=pMBEg@mail.gmail.com>
References: <1505975982-28314-1-git-send-email-jananis37@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Janani Sankara Babu <jananis37@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1505975982-28314-1-git-send-email-jananis37@gmail.com>
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

Hi Janani,

On Thu, Sep 21, 2017 at 9:39 AM, Janani Sankara Babu
<jananis37@gmail.com> wrote:
> This patch is created to solve the following warning shown by the checkpatch
> script Warning: Replace all occurences of (1<<x) by BIT(x)
>
> Signed-off-by: Janani Sankara Babu <jananis37@gmail.com>

Thank you for the patch - unfortunately, such a fix s already present
in the staging-next tree.

I suggest you base your patches to ccree on that tree as it is the
most current for this driver.

Thanks again,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
