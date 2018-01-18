From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 1/7] staging: ccree: remove ccree from staging tree
Date: Thu, 18 Jan 2018 10:39:11 +0200
Message-ID: <CAOtvUMeypjMxhC0CxSf_+Pj2K5ZZGVXRzO1BtBwv7_2V_0vP-w@mail.gmail.com>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
 <1515662239-1714-2-git-send-email-gilad@benyossef.com>
 <20180113132100.GC17515@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180113132100.GC17515@kroah.com>
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

On Sat, Jan 13, 2018 at 3:21 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jan 11, 2018 at 09:17:08AM +0000, Gilad Ben-Yossef wrote:
>> Remove the ccree driver from the staging tree in preparation to
>> introducing it in the crypto tree.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
> Heh, no, just make a patch series that adds the driver to the correct
> location in the crypto tree.
>
> If that gets accepted, we can then delete the staging driver with a
> separate patch, after the fact.  No need for it to be in this patch
> series.

Yes, I should have been more communicative as to why I am doing this, sorry.

The problem is that if you apply the patch adding the driver to
drivers/crypto/ the kernel
no longer links due to symbol name collisions.

If we really must avoid doing an "atomic" replacement I guess I can change the
Kconfig name to ...CCREE_OLD or something although I would prefer not doing
that so that people using the driver in staging/ don't need to change
their kernel
build configs when they are upgrading versions.

Does that makes sense?

Thanks,
Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
