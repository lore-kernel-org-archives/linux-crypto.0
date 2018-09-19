From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] Fix static checker warning
Date: Wed, 19 Sep 2018 16:57:42 +0300
Message-ID: <20180919135741.5icpyesntcfbgtcr@mwanda>
References: <cover.1536959537.git.Janakarajan.Natarajan@amd.com>
 <31c49295223e51f5c1c4e36e7a09fe100dab1711.1536959537.git.Janakarajan.Natarajan@amd.com>
 <8dfca0f4-6639-3444-148f-eb0b0817fec6@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
To: Gary R Hook <ghook@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8dfca0f4-6639-3444-148f-eb0b0817fec6@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Sounds reasonable.  The subject needs a subsystem prefix and it might
be better to make it more specific.  Like so:

[PATCH 1/2] crypto: ccp - potential uninitialized variable

I don't know if Herbert fixes those things up himself normally?

regards,
dan carpenter
