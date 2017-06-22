From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 0/7] staging: ccree: bug fixes and TODO items for 4.13
Date: Thu, 22 Jun 2017 11:37:47 +0300
Message-ID: <CAOtvUMc-N5qVJr16f9fDEK7DOshhd9176iQJVBRjLj2pE6ufBw@mail.gmail.com>
References: <1498115276-1601-1-git-send-email-gilad@benyossef.com>
 <CAOtvUMdwb44bCEM7kuOSuNVZjFOV083H1_+kqZ2F4ppQrPQh+A@mail.gmail.com>
 <20170622082813.akymrchk2xqctplw@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170622082813.akymrchk2xqctplw@mwanda>
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

On Thu, Jun 22, 2017 at 11:28 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> On Thu, Jun 22, 2017 at 10:14:08AM +0300, Gilad Ben-Yossef wrote:
>> On Thu, Jun 22, 2017 at 10:07 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> > An assortment of bug fixes and staging TODO items.
>> > Highlights includes the driver passing crypto testmgr boot tests
>> > and support of multiple HW revs. without build time changes.
>> >
>> > Gilad Ben-Yossef (7):
>> >   staging: ccree: fix hash import/export
>> >   staging: ccree: register setkey for none hash macs
>> >   staging: ccree: add support for older HW revisions
>> >   staging: ccree: remove unused function
>> >   staging: ccree: add clock management support
>> >   staging: ccree: add DT bus coherency detection
>> >   staging: ccree: use signal safe completion wait
>>
>> One additional note: the patch set is on top of the current staging-next which
>> is d06838de4a015c7c4844ad3fcf63ad5e2c17b234 so it will conflict with
>> the coding style clean up patches from Jhin-Ming if you take them.
>>
>> If you wish me to merge this patch set on top those just let me know.
>>
>
> Yes.  Those are fine and will be merged most likely.  It's strictly
> first in, first out.

Sure. I'll send an updated patch on top of those then.

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
