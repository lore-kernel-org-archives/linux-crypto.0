From: Maninder Singh <maninder1.s@samsung.com>
Subject: Re: [PATCH 0/1] cover-letter/lz4: Implement lz4 with dynamic offset
 length.
Date: Mon, 02 Apr 2018 11:33:54 +0530
Message-ID: <20180402060354epcms5p391e8f43648898d6d7dbd2ceb274f3cd9@epcms5p3>
References: <20180321064128.GA468@jagdpanzerIV>
        <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
        <CGME20180321044137epcas5p221e7ee4a0b7464eaa00dad8320f0251d@epcms5p3>
Reply-To: maninder1.s@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PANKAJ MISHRA <pankaj.m@samsung.com>,
        AMIT SAHRAWAT <a.sahrawat@samsung.com>,
        Vaneet Narang <v.narang@samsung.com>
To: "sergey.senozhatsky.work@gmail.com"
        <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180321064128.GA468@jagdpanzerIV>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


=C2=A0Hello,=0D=0A=0D=0A>>=20(Added=20cover=20letter=20to=20avoid=20much=20=
text=20in=20patch=20description)=0D=0A>>=20=0D=0A>>=20LZ4=20specification=
=20defines=202=20byte=20offset=20length=20for=2064=20KB=20data.=0D=0A>>=20B=
ut=20in=20case=20of=20ZRAM=20we=20compress=20data=20per=20page=20and=20in=
=20most=20of=0D=0A>>=20architecture=20PAGE_SIZE=20is=204KB.=20So=20we=20can=
=20decide=20offset=20length=20based=0D=0A>>=20on=20actual=20offset=20value.=
=20For=20this=20we=20can=20reserve=201=20bit=20to=20decide=20offset=0D=0A>>=
=20length=20(1=20byte=20or=202=20byte).=202=20byte=20required=20only=20if=
=20ofsset=20is=20greater=20than=20127,=0D=0A>>=20else=201=20byte=20is=20eno=
ugh.=0D=0A>=20=0D=0A>So=20what=20happens=20if=20I=20compress=20the=20data=
=20on=20a=20system=20with=20no=20dyn=0D=0A>offset=20and=20then=20send=20it=
=20over=20the=20network=20to=20a=20machine=20which=20has=0D=0A>dyn=20offset=
?=20Or,=20say,=20I=20have=20a=20USB=20stick=20with=20a=20compression=20enab=
led=0D=0A>FS,=20store=20files=20on=20a=20dyn=20offset=20enabled=20PC=20and=
=20then=20mount=20that=20USB=0D=0A>stick=20on=20a=20machine=20with=20no=20d=
yn=20offset=20support.=20And=20vice=20versa.=0D=0A=0D=0A=0D=0Alz4_dyn=20is=
=20not=20an=20extension=20of=20LZ4=20so=20there=20is=20no=20backward=20comp=
atibility.=0D=0AConsider=20this=20as=20a=20different=20algorithm=20adapted=
=20from=20LZ4=20for=20better=20compression=20ratio.=0D=0A=0D=0AThanks=0D=0A=
Maninder=20Singh
