Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33492 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbeLNH5I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Dec 2018 02:57:08 -0500
Date: Fri, 14 Dec 2018 09:56:56 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Louis Collard <louiscollard@chromium.org>
Cc: linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gary R Hook <gary.hook@amd.com>, Michael Buesch <m@bues.ch>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, apronin@chromium.org,
        linux@mniewoehner.de, david.bild@xaptum.com, tytso@mit.edu
Subject: Re: [PATCH v2] Allow hwrng to initialize crng.
Message-ID: <20181214075656.GA1721@linux.intel.com>
References: <20181213091848.81327-1-louiscollard@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213091848.81327-1-louiscollard@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 13, 2018 at 05:18:48PM +0800, Louis Collard wrote:
> Some systems, for example embedded systems, do not generate
> enough entropy on boot through interrupts, and boot may be blocked for
> several minutes waiting for a call to getrandom to complete.
> 
> Currently, random data is read from a hwrng when it is registered,
> and is loaded into primary_crng. This data is treated in the same
> way as data that is device-specific but otherwise unchanging, and
> so primary_crng cannot become initialized with the data from the
> hwrng.
> 
> This change causes the data initially read from the hwrng to be
> treated the same as subsequent data that is read from the hwrng if
> it's quality score is non-zero.
> 
> The implications of this are:
> 
> The data read from hwrng can cause primary_crng to become
> initialized, therefore avoiding problems of getrandom blocking
> on boot.
> 
> Calls to getrandom (with GRND_RANDOM) may be using entropy
> exclusively (or in practise, almost exclusively) from the hwrng.
> 
> Regarding the latter point; this behavior is the same as if a
> user specified a quality score of 1 (bit of entropy per 1024 bits)
> so hopefully this is not too scary a change to make.
> 
> This change is the result of the discussion here:
> https://patchwork.kernel.org/patch/10453893/

Please remove these two lines.

> Signed-off-by: Louis Collard <louiscollard@chromium.org>
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---

The change log seems to be missing before diffstat, after dashes.

/Jarkko
