From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/3] crypto: Fix potential leak in test_aead_speed() if aad_size is too big
Date: Wed, 23 Apr 2014 19:44:41 +0200
Message-ID: <201404231944.41781.marex@denx.de>
References: <20140421204439.7999f1c6@spike> <201404230133.05256.marex@denx.de> <20140423194335.2d72d7a4@spike>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christian Engelmayer <cengelma@gmx.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140423194335.2d72d7a4@spike>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday, April 23, 2014 at 07:43:35 PM, Christian Engelmayer wrote:
> On Wed, 23 Apr 2014 01:33:05 +0200, Marek Vasut <marex@denx.de> wrote:
> > On Monday, April 21, 2014 at 08:45:59 PM, Christian Engelmayer wrote:
> > > +	if (aad_size >= PAGE_SIZE) {
> > 
> > On an unrelated note ... Won't if (aad_size > PAGE_SIZE) be sufficient
> > here?
> 
> From what I have seen how the buffers are allocated via __get_free_page() I
> thought so too. However, as it previously read
> 
> 	if (aad_size < PAGE_SIZE)
> 		memset(assoc, 0xff, aad_size);
> 	else {
> 
> my intention was simply to make the modification so that the bug is
> addressed without introducing an additional change.

I fully agree with you. I was just curious about the comparison here.

Best regards,
Marek Vasut
