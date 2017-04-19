From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 0/4] staging: add ccree crypto driver
Date: Wed, 19 Apr 2017 17:40:22 +0300
Message-ID: <CAOtvUMfUzQY4sY7iZeEv6PzUxXq73f4Yyo+0pq3OAV3uSEc1RA@mail.gmail.com>
References: <1492524470-13847-1-git-send-email-gilad@benyossef.com>
 <20170418151355.GI17866@leverpostej> <CAOtvUMeB8ub-e6PXxgJWyK=TW4HseZgSN6NO=kSmVax514ufdg@mail.gmail.com>
 <20170418154349.GJ17866@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad.benyossef@arm.com>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:33196 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935455AbdDSOke (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 10:40:34 -0400
Received: by mail-yb0-f172.google.com with SMTP id 81so5971875ybp.0
        for <linux-crypto@vger.kernel.org>; Wed, 19 Apr 2017 07:40:29 -0700 (PDT)
In-Reply-To: <20170418154349.GJ17866@leverpostej>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 18, 2017 at 6:43 PM, Mark Rutland <mark.rutland@arm.com> wrote:
...
>> >>
>> >> The code still needs some cleanup before maturing to a proper
>> >> upstream driver, which I am in the process of doing. However,
>> >> as discussion of some of the capabilities of the hardware and
>> >> its application to some dm-crypt and dm-verity features recently
>> >> took place I though it is better to do this in the open via the
>> >> staging tree.
>> >>
>> >> A Git repository based off of Linux 4.11-rc7 is available at
>> >> https://github.com/gby/linux.git branch ccree.
>> >>
...
>> >>  .../devicetree/bindings/crypto/arm-cryptocell.txt  |   23 +
>> >
>> > I'm interested in looking at the DT binding, but for some reason I've
>> > only recevied the cover letter so far.
>> >
>> > Are my mail servers being particularly slow today, or has something gone
>> > wrong with the Cc list for the remaining patches?
>> >
>>
>> Thanks a bunch for the willingness to review this.
>>
>> My apologies for not communicating this clearly enough -  Since it is
>> an pre-existing driver it is rather big.
>> I did not want to inflict a 600K patch on the mailing list so opted to
>> provide a git repo instead, as stated in the
>> email.
>
> Should this have been a [GIT PULL], then?
>
> I was confused by the [PATCH 0/4].

Yes, it should have. Sorry about that.
>
>> The patch in question is here:
>> https://github.com/gby/linux/commit/12d92e0bc19aa9bbd891cdab765eaaeabe0b6967
>>
>> Do let me know if you prefer that I will send at least the smaller
>> patch file via email in the normal fashion.
>
> Sending patches is the usual way to have things reviewed. Linking to an
> external site doesn't fit with the workflows of everyone.
>
> If you wish to have patches reviewed, please send them as patches in the
> usual fashion.

Thanks for the feedback.
I will break the driver up and post patches in the normal fashion.

>
> I will note that on the patch you linked, the compatible string is far
> too vague, per common conventions. Per your description above, that
> should be something like "arm,cryptocell-712-ree" (and each variant
> should have its own string).

Got it. Will change.

Thanks for the review even in this unconventional form :-) !

>
> I don't have documentation to hand to attempt to review the rest.
>
> I would appreciate if you could ensure that the DT binding was reviewed
> as part of the staging TODOs. That needs to follow the usual DT review
> process of sending patches to the list. Until that has occurred, it
> shouldn't be in Documentation/devicetree/.

Of course, will do.

Thanks,
Gilad
>
> Thanks,
> Mark.



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
