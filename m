From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] staging: ccree: local variable "dev" not required
Date: Thu, 05 Oct 2017 11:00:31 -0700
Message-ID: <1507226431.4434.37.camel@perches.com>
References: <1507144330-1672-1-git-send-email-sunil.m@techveda.org>
         <CAOtvUMc3oVFxpgrj9i26_ETCG1CAr0Kj=77Lc2xVNdEPii-RkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        karthik@techveda.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Suniel Mahesh <sunil.m@techveda.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0125.hostedemail.com ([216.40.44.125]:46381 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751332AbdJESAf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Oct 2017 14:00:35 -0400
In-Reply-To: <CAOtvUMc3oVFxpgrj9i26_ETCG1CAr0Kj=77Lc2xVNdEPii-RkQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2017-10-05 at 10:07 +0300, Gilad Ben-Yossef wrote:
> On Wed, Oct 4, 2017 at 10:12 PM,  <sunil.m@techveda.org> wrote:
> > There is no need to create a local pointer variable "dev" and
> > pass it various API's, instead use plat_dev which is enumerated
> > by platform core on successful probe.
[]
> I'm sorry but I don't understand what is the problem you are trying to solve or
> what is the improvement suggested.
> 
> Why is having a local variable undesirable? I think having it makes
> the code more readable, not less.

IMO: The local variable is _not_ undesirable.
     It does make the code more readable and
     shortens line lengths too.
