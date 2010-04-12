From: john terragon <terragonjohn@yahoo.com>
Subject: Re: aesni-intel slower than aes-x86_64
Date: Mon, 12 Apr 2010 10:09:36 -0700 (PDT)
Message-ID: <263254.5283.qm@web45116.mail.sp1.yahoo.com>
References: <4BC3150A.1080905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web45116.mail.sp1.yahoo.com ([68.180.197.184]:24866 "HELO
	web45116.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752441Ab0DLRJg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Apr 2010 13:09:36 -0400
In-Reply-To: <4BC3150A.1080905@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



--- On Mon, 4/12/10, Milan Broz <mbroz@redhat.com> wrote:

> From: Milan Broz <mbroz@redhat.com>
> Subject: Re: aesni-intel slower than aes-x86_64
> To: "john terragon" <terragonjohn@yahoo.com>
> Cc: linux-crypto@vger.kernel.org
> Date: Monday, April 12, 2010, 5:41 AM
> On 04/12/2010 12:52 AM, john terragon
> wrote:
> > My system has a core i5 520M and supports AES-NI. I
> wanted to do a
> > rude performance test and so I ran these commands on a
> small (4GB) partition and on the dm-crypt device backed by
> it:
> >=20
> > 1) using the aesni-intel module: dd
> if=3D/dev/dev/mapper/vol of=3D/dev/null bs=3D4k
> > 2) using only the generic aes-x86_64 module: dd
> if=3D/dev/dev/mapper/vol
> > of=3D/dev/null bs=3D4k
> > 3) dd if=3D/dev/sda4 of=3D/dev/null bs=3D4k=20
> >=20
> > What I got kind of surprised me:
> > 1) ~ 67 MB/sec, with a low cpu load by kcryptd
> > 2) ~ 79 MB/sec, with a higher cpu load by kcryptd
> > 3) ~ 81 MB/sec
>=20
> Just curious=A0 - is it the same if you add
> iflag=3Ddirect? Also try larger block size bs=3D1M etc.
>=20

With iflag=3Ddirect I get about 1.2 MB/sec more or less in all the thre=
e cases. With bs=3D1M I get slightly better results in all the three ca=
ses
however the increase for aesni is proportionally less than the other tw=
o cases. So the performance differences are even slightly larger with b=
s=3D1M. I don't get it. As it is, it seems that the  aes new instructio=
ns are practically useless (with my core i5 520M, at least).

John

=20


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
