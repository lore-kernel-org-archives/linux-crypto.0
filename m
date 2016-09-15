From: Stephan Mueller <smueller@chronox.de>
Subject: Re: CONFIG_FIPS without module loading support?
Date: Thu, 15 Sep 2016 20:31:50 +0200
Message-ID: <6107281.W3KhHGMqrJ@tauon.atsec.com>
References: <CAM5Ud7Pw84GcjpooX_5VfBuRTgU8+HMKkM6GBnD1z=JEw0PkXw@mail.gmail.com> <2523179.y8adHMcoDs@tauon.atsec.com> <CAM5Ud7PsjjrR0Ta6RFJbxcxXqVj7aEwzWF__7TEKpxun96NhdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: NTU <neotheuser@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47972 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752027AbcIOSby (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 14:31:54 -0400
In-Reply-To: <CAM5Ud7PsjjrR0Ta6RFJbxcxXqVj7aEwzWF__7TEKpxun96NhdQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. September 2016, 12:06:20 CEST schrieb NTU:

Hi NTU,

> What did I miss from the SubmittingPatches page? Some constructive

The patch should be inline to the email -- see all other patch submissions. 
Then, the email subject should be appropriate.

> criticism please? Step 1 is skipped due to the fact I'm using git,
> patch is in proper form. Step 2, I described the patch. 3, it's one
> line, so it cannot be separated. Step 4, checkpatch.pl says it's good.
> The section in 5 confused me a little bit. 6, the patch is plain text.
> 7, it is under 300k (easily.) 8, doing it right now. 9, ok. 10, PATCH
> is included in the subject. 11, it is signed, says signed off at the
> bottom of the comment section. 12 I don't think is applicable to this?
> 13, not applicable again? 14, it is in canonical format, comment lines
> do not exceed 70 characters, it has a marker line, diff output etc. 15
> confused me a little. 16 it is not a series of patches.
> 
> If ANSI_CPRNG is not approved anymore for FIPS, the help section
> should be updated then.
> 
> As for converting the DRBG booleans to choice, it is so that way users
> cannot have both options disabled, in the case they don't read the
> help for it.
> 
> Alec
> 
> On Wed, Sep 14, 2016 at 11:58 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Mittwoch, 14. September 2016, 19:18:43 CEST schrieb NTU:
> > 
> > Hi NTU,
> > 
> >> Hello,
> >> 
> >> I've never written a patch before to the official kernel mailing list
> >> (that I remember) so please forgive me if I didn't send this in
> >> properly. I've generated this using git format-patch HEAD~ --stdout &>
> >> kconfig_fix_for_fips.patch and have attached the file in this email,
> >> gathering as much as I could from the Documentation/SubmittingPatches
> >> page.
> > 
> > Please read Documentation/SubmittingPatches
> > 
> >> Few more things, in the help option for CRYPTO_ANSI_CPRNG, it says it
> >> must be enabled if FIPS is selected, but in the dependencies for FIPS,
> >> if DRBG is selected, then CRYPTO_ANSI_CPRNG doesn't need to be
> >> enabled. Which one is true?
> > 
> > The latter one. The X9.31 DRNG is not approved in FIPS mode any more.
> > 
> >> Secondly, in the help option for CRYPTO_DRBG_MENU, it says that one or
> >> more of the DRBG types must be selected. If this is indeed true,
> >> shouldn't the options within CRYPTO_DRBG_MENU be converted to
> >> choice/endchoice versus just booleans? One selection for
> >> CRYPTO_DRBG_HASH, another for CRYPTO_DRBG_CTR, and then a third option
> >> for both? Should I submit patches for these as well,
> >> feedback/thoughts?
> > 
> > Not sure what you want to gain from it. All that the booleans do is to
> > mark
> > which types of DRBG are to be compliled. The selector whether the DRBG is
> > compiled at all is CRYPTO_DRBG.
> > 
> > Ciao
> > Stephan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ciao
Stephan
