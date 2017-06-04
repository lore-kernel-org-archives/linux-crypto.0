From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 02/20] staging: ccree: replace bit shift with BIT macro
Date: Sun, 4 Jun 2017 08:31:55 +0300
Message-ID: <CAOtvUMfHdTz1oEeQgtok=WcEKQ20gOM4XSnb-mWKxArZXw+NQQ@mail.gmail.com>
References: <1496314993-30229-1-git-send-email-gilad@benyossef.com>
 <1496314993-30229-3-git-send-email-gilad@benyossef.com>
 <20170603084610.GA13935@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Joe Perches <joe@perches.com>,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170603084610.GA13935@kroah.com>
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

On Sat, Jun 3, 2017 at 11:46 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 01, 2017 at 02:02:52PM +0300, Gilad Ben-Yossef wrote:
>> CC_CTX_SIZE was being defined using a hand rolled bit shift operation.
>> Replace with use of BIT macro.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> ---
>>  drivers/staging/ccree/cc_crypto_ctx.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> This patch didn't apply at all, are you sure you are working against the
> correct tree?  I've tried to apply some of this series, but most do not
> work at all...
>

Yes, I did. The patch series was created against your staging/staging-next
at commit ca9280d1f82a7a0165a683dc09f182329ebec352

What I believe might have happened is that you took in Gennadii Altukhov's
and Derek Robson's patch set and mine indeed no longer applies on top of theirs.

> Please rebase against my staging-next branch and resend the ones that do
> work.

Sure, I'll rebase on top of current staging/staging-next and resend
the remaining
patches

Thanks,
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
