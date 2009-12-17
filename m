From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR offload
Date: Thu, 17 Dec 2009 10:44:26 -0700
Message-ID: <4B2A6DFA.6000504@intel.com>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com> <20091216164144.daff5468.kim.phillips@freescale.com> <2868C8CF-584B-4FA7-9C3B-2FACEF77527E@kernel.crashing.org> <4B296394.9010709@intel.com> <20091217170958.GE18271@ovro.caltech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kumar Gala <galak@kernel.crashing.org>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"B04825@freescale.com" <B04825@freescale.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
	Vishnu Suresh <Vishnu@freescale.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Dipen Dudhat <Dipen.Dudhat@freescale.com>,
	Maneesh Gupta <Maneesh.Gupta@freescale.com>,
	"R58472@freescale.com" <R58472@freescale.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091217170958.GE18271@ovro.caltech.edu>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Ira W. Snyder wrote:
> Yes, I have used the device_prep_dma_interrupt() functionality quite a
> while back. However, I found it to be pretty much useless.

The specific case it is needed for Talitos/raid is a channel switch 
interrupt.  The interrupt causes the cleanup operation to be run which 
will kick off any pending dependent operations on the xor channel.  In 
the raid case we only have callbacks at the end of a chain, so we need 
the interrupt to kick the engine in an operation chain like 
xor->copy->xor->callback.

--
Dan
