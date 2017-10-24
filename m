From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging: ccree: Fix lines longer than 80 characters
Date: Tue, 24 Oct 2017 11:49:41 +0300
Message-ID: <CAOtvUMfZVAEFqzNtsYtABhK9=ngVAJOym9as1RrxVsyvmU4weA@mail.gmail.com>
References: <20171023145318.8748-1-stephen@brennan.io>
 <20171024030245.GC1429@eros>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, Stephen Brennan <stephen@brennan.io>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Tobin C. Harding" <me@tobin.cc>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20171024030245.GC1429@eros>
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

Hi Tobin,

On Tue, Oct 24, 2017 at 6:02 AM, Tobin C. Harding <me@tobin.cc> wrote:
> On Mon, Oct 23, 2017 at 07:53:18AM -0700, Stephen Brennan wrote:
>> Simply break down some long lines and tab-indent them.
>
> Hi Stephen,
>
> Welcome to the Linux kernel. Great that you have put in a patch, you are, however, unlikely to see
> success fixing 'line over 80' warnings. There are a bunch of arguments for and against the line over
> 80 limit, a web search will surely show them to you. The TL;DR is that it these changes do not
> _really_ improve the readability of the code, they are just changes to quiet the static analysis
> tool.

I completely agree with you that the end target is more readable code
and that lines over 80 char is
only a symptom but I do think in this case there is something useful to do.

Perhaps, if Stephen is willing, re-write the code to be more readable
by, for example, using a temp
variable for the register address, and in doing so both making the
code more readable as well as
treating the symptom?

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
