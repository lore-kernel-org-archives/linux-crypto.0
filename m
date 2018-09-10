From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: rng_dev_read: Kernel memory exposure attempt detected from SLUB
 object 'kmalloc-64'
Date: Mon, 10 Sep 2018 16:42:19 -0400
Message-ID: <20180910204219.GG16557@thunk.org>
References: <alpine.LRH.2.21.1809102006280.8926@math.ut.ee>
 <20180910195342.GD16557@thunk.org>
 <CAKv+Gu-GUdYgy=cJnD5-HB3c2vxv53YbzY10CATocqP2DQrAwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Meelis Roos <mroos@linux.ee>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-GUdYgy=cJnD5-HB3c2vxv53YbzY10CATocqP2DQrAwg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 10, 2018 at 10:02:38PM +0200, Ard Biesheuvel wrote:
> >> [146535.257274] tpm tpm0: A TPM error (379) occurred attempting get random
> >> [146535.257304] usercopy: Kernel memory exposure attempt detected from SLUB object 'kmalloc-64' (offset 0, size 379)!
> 
> The TPM return code '379' is returned from rng_get_data(), and
> interpreted as a byte count rather than an error code.

So there are two bugs here.  Once is in the TPM hw_random driver; it
shouldn't be returning the TPM error code.  The second is that
rng_dev_read() should be more suspicious and validate the number of
bytes returned from the low-level hw_random driver for sanity.

      	       	    		  	    - Ted
