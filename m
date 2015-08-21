From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 1/2] Fixing vmx-crypto AES-CTR counter bug
Date: Fri, 21 Aug 2015 15:19:18 -0400
Message-ID: <CAP=VYLr59L+1fi0UDjQPVmEOUbT-KnmpLY562mACHxsRqHEk3A@mail.gmail.com>
References: <20150814131218.GA11746@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	LKML <linux-kernel@vger.kernel.org>,
	Paulo Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
To: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20150814131218.GA11746@bluepex.com>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 14, 2015 at 9:12 AM, Leonidas S Barbosa
<leosilva@linux.vnet.ibm.com> wrote:
> AES-CTR is using a counter 8bytes-8bytes what miss match with
> kernel specs.
>
> In the previous code a vadduwm was done to increment counter.
> Replacing this for a vadduqm now considering both cases counter
> 8-8 bytes and full 16bytes.

Seems this breaks ppc allmodconfig:

drivers/crypto/vmx/aesp8-ppc.S:1545: Error: Unrecognized opcode: `vadduqm'

1d4aa0b4c1816e8ca92a6aadb0d8f6b43c56c0d0 is the first bad commit
commit 1d4aa0b4c1816e8ca92a6aadb0d8f6b43c56c0d0
Author: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Date:   Fri Aug 14 10:12:22 2015 -0300

    crypto: vmx - Fixing AES-CTR counter bug


   http://kisskb.ellerman.id.au/kisskb/buildresult/12490159/


Paul.
--

>
> Signed-off-by: Leonidas S Barbosa <leosilva@linux.vnet.ibm.com>
> ---
>  drivers/crypto/vmx/aes_ctr.c    |  8 +++++++-
>  drivers/crypto/vmx/aesp8-ppc.pl | 34 +++++++++++++++++-----------------
>  2 files changed, 24 insertions(+), 18 deletions(-)
>
>
