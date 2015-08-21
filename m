From: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Fixing vmx-crypto AES-CTR counter bug
Date: Fri, 21 Aug 2015 17:15:24 -0300
Message-ID: <20150821201522.GA18207@bluepex.com>
References: <20150814131218.GA11746@bluepex.com>
 <CAP=VYLr59L+1fi0UDjQPVmEOUbT-KnmpLY562mACHxsRqHEk3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	LKML <linux-kernel@vger.kernel.org>,
	Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAP=VYLr59L+1fi0UDjQPVmEOUbT-KnmpLY562mACHxsRqHEk3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 21, 2015 at 03:19:18PM -0400, Paul Gortmaker wrote:
> On Fri, Aug 14, 2015 at 9:12 AM, Leonidas S Barbosa
> <leosilva@linux.vnet.ibm.com> wrote:
> > AES-CTR is using a counter 8bytes-8bytes what miss match with
> > kernel specs.
> >
> > In the previous code a vadduwm was done to increment counter.
> > Replacing this for a vadduqm now considering both cases counter
> > 8-8 bytes and full 16bytes.
> 
> Seems this breaks ppc allmodconfig:
> 
> drivers/crypto/vmx/aesp8-ppc.S:1545: Error: Unrecognized opcode: `vadduqm'

Thanks for report,

I could not reproduce this issue, but I believe it's a opcode map error
on ppc-xlate.pl. Sending a patch followed by this email you CCed.
