From: Dan Streetman <ddstreet@us.ibm.com>
Subject: Re: [PATCH 5/6] [RFC] crypto/testmgr: add null test for 842 algorithm
Date: Wed, 15 Jul 2015 10:25:04 -0400
Message-ID: <CALZtONDqrO=Sq56efLtvMMtgwBY54FDp4mq9=XZ5JWFD26XSbw@mail.gmail.com>
References: <20150702223800.GA1712@linux.vnet.ibm.com> <20150702224119.GF1712@linux.vnet.ibm.com>
 <20150704072453.GC6153@gondor.apana.org.au> <20150714000536.GA38815@linux.vnet.ibm.com>
 <20150714000558.GB38815@linux.vnet.ibm.com>
Reply-To: ddstreet@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	gustavold@linux.vnet.ibm.com
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34447 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbbGOOZY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 10:25:24 -0400
Received: by igvi1 with SMTP id i1so78296419igv.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2015 07:25:24 -0700 (PDT)
In-Reply-To: <20150714000558.GB38815@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 13, 2015 at 8:05 PM, Nishanth Aravamudan
<nacc@linux.vnet.ibm.com> wrote:
> On 13.07.2015 [17:05:36 -0700], Nishanth Aravamudan wrote:
>> On 04.07.2015 [15:24:53 +0800], Herbert Xu wrote:
>> > On Thu, Jul 02, 2015 at 03:41:19PM -0700, Nishanth Aravamudan wrote:
>> > > Currently, when the nx-842-pseries driver loads, the following message
>> > > is emitted:
>> > >
>> > > alg: No test for 842 (842-nx)
>> > >
>> > > It seems like the simplest way to fix this message (other than adding a
>> > > proper test) is to just insert the null test into the list in the
>> > > testmgr.
>> > >
>> > > Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
>> >
>> > Please add some real test vectors instead.
>
> Apologies, hit send too fast. I'll work with Dan on this when he gets
> back from vacation.

Back from vacation! :-)

I originally didn't add any test vector for NX 842 because the main
driver was loading before the "platform" (pseries/powernv) drivers,
and the test couldn't run as the platform driver hadn't loaded yet.
That's now fixed so we should be able to add a real test for NX 842
now, I can work on that patch.

>
> -Nish
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
