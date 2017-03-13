From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt IV generation (summary)
Date: Mon, 13 Mar 2017 14:23:52 -0400
Message-ID: <20170313182344.GA11766@redhat.com>
References: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
To: Ondrej Mosnacek <omosnace@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35296 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751141AbdCMSXy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Mar 2017 14:23:54 -0400
Content-Disposition: inline
In-Reply-To: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 10 2017 at  8:44am -0500,
Ondrej Mosnacek <omosnace@redhat.com> wrote:

> Hi all,
> 
> I was tasked to post a summary the whole dm-crypt IV generation
> problem and all the suggested solutions along with their drawbacks, so
> here it goes...

Thanks for the summary.
...
 
> 2. Restrict the keycount parameter to allow only reasonable
> combinations and then move IV generators to crypto API.
>     In Loop-AES, the multi-key mode always uses exactly 64 keys and
> there is no reasonable scenario where someone would like to use
> keycount != 1 with other IV mode than LMK. Thus it might be acceptable
> to only work with multiple keys in LMK (and only allow keycount == 64
> for it) and work with just one key in all other modes (and only allow
> keycount == 1 for them). I.e., the cipher format would remain the
> same, just with more restricted values.
> 
>     Note that this would be basically a breaking change (the keycount
> parameter is documented [4], so there may be users somewhere that use
> it in some unusual combination...). Still, such combinations would
> have to be used explicitly, as they are never used with common
> LUKS/Loop-AES/TrueCrypt partitions (something like cryptsetup --type
> plain ... or dmsetup would have to be used directly).
> 
>     Applying this change would allow implementing the IV generators as
> simple crypto algorithms that honor the usual interface (without
> setkey hacks and passing of special structures via IV).
> 
>     ISSUES:
>         a) Backward incompatibility (see above).
>         b) Again need to somehow handle the new 'random' IV generator.

...
> 
> QUESTIONS:
> @Mike/dm-devel: Do you think it would be feasible to apply solution 2
> (thus introducing the small incompatibility)?

Of all the proposals I think 2 is the best.  But I'm not in a position
to _know_ how problematic such an incompatible change would be.  As such
I unfortunately would need to defer to Milan, Herbert and others to say
how risky such a change would be.  If the real-world risk is very
limited then I think it would enable the most effective solution (moving
the IV generators to crypto without carrying excess dm-crypt baggage).

The other part mentioned ("need to somehow handle the new 'random' IV
generator"): Milan or others, do you have ideas for this?  Presummably
that is a prereq to moving forward with restricting keycount.

Mike
