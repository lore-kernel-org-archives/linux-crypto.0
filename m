From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] random: addu a config option to trust the CPU's hwrng
Date: Thu, 19 Jul 2018 10:21:48 -0400
Message-ID: <20180719142148.GH30706@thunk.org>
References: <20180718014344.1309-1-tytso@mit.edu>
 <20180718015154.GE3489@thunk.org>
 <CACXcFmk7D5t9yg9VxhKZgMvqK-LmFF0d7Dh9A3hsoGTfzzeM8A@mail.gmail.com>
 <20180718173621.GC30706@thunk.org>
 <CACXcFm=URq_UnqdeEUAV0i6DSkvhE8VZW0KYcgQ=7601q_5NnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACXcFm=URq_UnqdeEUAV0i6DSkvhE8VZW0KYcgQ=7601q_5NnQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 18, 2018 at 04:22:35PM -0400, Sandy Harris wrote:
> 
> Yes & one of those can also solve any difficulty with random(4) at
> startup. Another alternative, perhaps easier on some systems, is
> Denker's Turbid trng:
> https://www.av8n.com/turbid/paper/turbid.htm

In the link above I saw breadboards with resistors plugged in,
alligator clips to TRG plugs, shield boxes with aluminum foil, and
doing calibrations using voltmeters.  While that induced a pleasant
flashback to my junior high days when I experimented with electronics,
I'm not entirely sure most sysadmins would call that "easy".  :-)

    		      	   	     	   	- Ted
