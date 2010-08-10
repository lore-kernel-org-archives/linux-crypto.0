From: "Loc Ho" <lho@apm.com>
Subject: RE: [PATCH 0/4] RFC: "New" /dev/crypto user-space interface
Date: Tue, 10 Aug 2010 11:12:59 -0700
Message-ID: <026401cb38b7$ab6402e0$022c08a0$@com>
References: <20100810164045.GH3390@hmsreliant.think-freely.org> <1588375167.142801281459463292.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "'Neil Horman'" <nhorman@tuxdriver.com>,
	"'Herbert Xu'" <herbert@gondor.hengli.com.au>,
	"'Nikos Mavrogiannopoulos'" <n.mavrogiannopoulos@gmail.com>,
	<linux-crypto@vger.kernel.org>, "'Linda Wang'" <lwang@redhat.com>,
	"'Steve Grubb'" <sgrubb@redhat.com>
To: "'Miloslav Trmac'" <mitr@redhat.com>,
	"'Neil Horman'" <nhorman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:48114 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932353Ab0HJSVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Aug 2010 14:21:09 -0400
Received: by pwi2 with SMTP id 2so240463pwi.32
        for <linux-crypto@vger.kernel.org>; Tue, 10 Aug 2010 11:21:09 -0700 (PDT)
In-Reply-To: <1588375167.142801281459463292.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Content-Language: en-us
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Miloslav,

I had read or glance over the patch from " http://people.redhat.com/mit=
r/cryptodev-ncr/0002". We have post a version of the CryptoDev over a y=
ear ago. Unfortunately, we did not got a chance to pick up again. In th=
at process, Herbert Xu provides a number of comments. You can search th=
e mailing list for that. Here are my comment based on experience with h=
ardware crypto:

1. This CrytoDev (user space) interface needs to support multiple opera=
tions at once
2. This CrytoDev interface needs to support async
3. This CryotDev interface needs to support large data operation such a=
s an entire file
4. Zero crypto (already see this in your version)
5. Avoid a lot of little kmalloc for various small structures (This onc=
e is from Herbert Xu.)
6. This interface needs to work with OpenSSL which allow OpenSwan to wo=
rk

Reason for item above:
Item #1. Multiple operations - This needs to take advance of the hardwa=
re offload. If you only submit one operation at a time, the latency of =
the software/hardware will be a problem. By allow submitting multiple o=
perations, you fill up the hardware buffer and keep in running. Otherwi=
se, it just be idle a majority of the time and the difference between S=
W vs HW is nill.

Item #2. Asnc - You can argue that you can open multiple /dev/crypto se=
ssion and submit them. But this does not work for the same session and =
for HW base crypto. Having an async interface has the benefit to the us=
er space application developer as they can use the same async programmi=
ng interface as with other I/O operations.

Item #3. Large file support - Most hardware algorithms can't support th=
is as the operation cannot be continue. Not sure how to handle this.

Item #4. Right now you are pining the entire buffer. For small buffer, =
this may not make sense. We have not got a chance to see if what is the=
 limit for this.

Item #5. Herbert Xu mentioned that we should avoid having a lot of smal=
l kmalloc when possible.

Item #6. You should give OpenSSL a patach and see how it works out. Alt=
hough, OpenSSL does not take advantage of batch submission. Again, to r=
eally take advantage of the HW, you really need to support batch operat=
ion.

=46or all other comments, search for previous /dev/cryptodev submission=
 and you will find a bunch of argue on this "user space crypto API".

-Loc


CONFIDENTIALITY NOTICE: This e-mail message, including any attachments,=
=20
is for the sole use of the intended recipient(s) and contains informati=
on=A0
that is confidential and proprietary to AppliedMicro Corporation or its=
 subsidiaries.=20
It is to be used solely for the purpose of furthering the parties' busi=
ness relationship.=20
All unauthorized review, use, disclosure or distribution is prohibited.=
=20
If you are not the intended recipient, please contact the sender by rep=
ly e-mail=20
and destroy all copies of the original message.
=0D
