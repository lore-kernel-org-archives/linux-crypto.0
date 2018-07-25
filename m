From: Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v6 13/18] wireless/lib80211: Convert from ahash to shash
Date: Wed, 25 Jul 2018 11:05:42 +0300
Message-ID: <87tvong2p5.fsf@purkki.adurom.net>
References: <20180724164936.37477-1-keescook@chromium.org>
 <20180724164936.37477-14-keescook@chromium.org>
 <1532503493.3223.0.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
 linux-wireless@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
 dm-devel@redhat.com, Jia-Ju Bai <baijiaju1990@gmail.com>,
 Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-afs@lists.infradead.org,
 Alasdair Kergon <agk@redhat.com>, Rabin Vincent <rabinv@axis.com>,
 devel@driverdev.osuosl.org, Herbert Xu <herbert@gondor.apana.org.au>,
 x86@kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
 qat-linux@intel.com, Ingo Molnar <mingo@redhat.com>, drbd-dev@lists.linbit.com,
 Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
 Tudor-Dan Ambarus <tudor.ambarus@microchip.com>, linux-block@vger.kernel.org,
 Josh Poimboeuf <jpo
To: Johannes Berg <johannes@sipsolutions.net>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1532503493.3223.0.camel@sipsolutions.net> (Johannes Berg's
 message of "Wed, 25 Jul 2018 09:24:53 +0200")
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

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2018-07-24 at 09:49 -0700, Kees Cook wrote:
>> In preparing to remove all stack VLA usage from the kernel[1], this
>> removes the discouraged use of AHASH_REQUEST_ON_STACK in favor of
>> the smaller SHASH_DESC_ON_STACK by converting from ahash-wrapped-shash
>> to direct shash. By removing a layer of indirection this both improves
>> performance and reduces stack usage. The stack allocation will be made
>> a fixed size in a later patch to the crypto subsystem.
>
> I think you sent this before - it should be in net-next now.

Yup, I see it in net-next:

d17504b16ea2 wireless/lib80211: Convert from ahash to shash

-- 
Kalle Valo
