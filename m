From: P J P <ppandit@redhat.com>
Subject: Re: [Part2 PATCH v4.1 07/29] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Wed, 4 Oct 2017 16:12:37 +0530 (IST)
Message-ID: <nycvar.YSQ.7.76.1710041551490.23099@wniryva>
References: <20170919204627.3875-8-brijesh.singh@amd.co> <20171002204831.5947-1-brijesh.singh@amd.com> <nycvar.YSQ.7.76.1710041221390.19122@wniryva> <20171004092152.4lmjlsqrg25dgaxu@pd.tnic> <nycvar.YSQ.7.76.1710041515170.22210@wniryva>
 <20171004100749.433dzszyea3oqcpn@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171004100749.433dzszyea3oqcpn@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

+-- On Wed, 4 Oct 2017, Borislav Petkov wrote --+
| This is a function which maps commands to buffer lengths and it should be 
| obvious at a *very* quick glance what it does. And that is best done if it 
| is written in a tabular manner as we do such things in other places in the 
| kernel too.

  Quick glance would work if it is readable. Currently it is not if one is 
viewing it in 80 cols screen/window. They do that. Writing return on the same 
line does not add specific value IMO.

Up to you; I pointed it out as 80 columns rule makes sense to me.

--
 - P J P
47AF CE69 3A90 54AA 9045 1053 DD13 3D32 FE5B 041F
