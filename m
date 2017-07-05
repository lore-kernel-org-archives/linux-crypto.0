From: "Ulrich Windl" <Ulrich.Windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org>
Subject: Antw: Re: [kernel-hardening] Re: [PATCH v4 06/13] iscsi:
 ensure RNG is seeded before use
Date: Wed, 05 Jul 2017 09:08:41 +0200
Message-ID: <595C9079020000A100026F37@gwsmtp1.uni-regensburg.de>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-7-Jason@zx2c4.com>
 <20170608024357.fhyyentj2qm7ti2q@thunk.org>
 <CAHmME9pViOqqDPyjXKLfCWSTnQrcE4OLJMdK1yaTiUvrOV+ecQ@mail.gmail.com>
 <fbca1b2b-c9ae-80ce-45ef-17c3d3b93e57@suse.com>
 <CAHmME9rU_H6Jq7ArjDq1yByrYf1P7nyC4Y8tqkzG585U39MFLg@mail.gmail.com>
 <02d60ed4-4207-dd7d-8826-0f9f7f4e966d@suse.com>
 <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: "David Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
 "Eric Biggers" <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 "open-iscsi" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 "Nicholas A.Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>,
 "Greg Kroah-Hartman" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
 "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>,
 "Ted Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>,"Chris Leech" <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 "Linux Crypto Mailing List" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jason A.Donenfeld" <Jason-OnJsPKxuuEcAvxtiuMwx3w@public.gmane.org>
To: "Lee Duncan" <lduncan-IBi9RG/b67k@public.gmane.org>
Return-path: <open-iscsi+bncBC6MFJWO34DBB7NA6LFAKGQELP4PU6I-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
List-Id: linux-crypto.vger.kernel.org

>>> Jeffrey Walton <noloader-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> schrieb am 17.06.2017 um 16:23 in N=
achricht
<CAH8yC8nHX2r9cfQ0gNeJAUrgSfAS8V16dVHv35BRnLn-YprZCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>:

[...]
> But its not clear to me how to ensure uniqueness when its based on
> randomness from the generators.

Even with a perfect random generator non-unique values are possible (that's=
 why it's random). It's unlikely, but it can happen. The question is whethe=
r the probability of non-unique values from /dev/urandom is any higher than=
 that for values read from /dev/random. One _might_ be able to predict the =
values from /dev/urandom.

Regards,
Ulrich

>=20
> Jeff
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
=20
> "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
=20
> email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> Visit this group at https://groups.google.com/group/open-iscsi.
> For more options, visit https://groups.google.com/d/optout.




--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
