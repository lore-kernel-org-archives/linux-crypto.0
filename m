From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v4 1/5] powerpc: io.h: move iomap.h include so that it can
 use readq/writeq defs
Date: Thu, 20 Jul 2017 09:39:33 -0600
Message-ID: <edcc1102-d29f-cd19-4103-8ea6719d5f12@deltatee.com>
References: <20170718165528.7383-1-logang@deltatee.com>
 <20170718165528.7383-2-logang@deltatee.com>
 <87iniphsug.fsf@concordia.ellerman.id.au>
 <15b6ea7d-5817-c0cd-aee4-c8a52d8808f9@deltatee.com>
 <VI1PR0401MB2591205D2621B5FEB4EAE2CC98A70@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <VI1PR0401MB259189A76FFD80DC02ACCF8998A70@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Bates <sbates@raithlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Suresh Warrier <warrier@linux.vnet.ibm.com>,
        Oliver O'Halloran <oohall@gmail.com>
To: =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-ntb@googlegroups.com" <linux-ntb@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <VI1PR0401MB259189A76FFD80DC02ACCF8998A70@VI1PR0401MB2591.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 20/07/17 06:36 AM, Horia Geantã wrote:
> include/asm-generic/iomap.h is included before
> include/linux/io-64-nonatomic-lo-hi.h:
> 
> include/linux/io.h -> arch/powerpc/include/asm/io.h ->
> include/asm-generic/iomap.h
> 
> Thus, the "extern" version of ioread64_lo_hi and friends will be used
> (and not the inline version from io-64-nonatomic-lo-hi.h).
> 
> But for this kernel .config:
> -CONFIG_GENERIC_IOMAP=n and
> -there is no implementation of io{read|write}64[be]{_lo_hi|_hi_lo} in
> arch/powerpc/kernel/iomap.c

Ah, thanks for the triage. I'll take a look at fixing this for a v5.

Logan
