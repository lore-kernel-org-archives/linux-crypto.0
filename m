From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/7] Makefile, x86, LLVM: disable unsupported optimization
 flags
Date: Fri, 17 Mar 2017 14:34:45 -0700
Message-ID: <74cbe721-40c0-f78c-7a55-9f4fcf63c7d3@zytor.com>
References: <20170317001520.85223-1-md@google.com>
 <20170317001520.85223-3-md@google.com>
 <ad94b647-4ba0-4ae9-be8f-6fe7e9406def@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Matthias Kaehlcke <mka@chromium.org>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Michael Davidson <md@google.com>, Michal Marek <mmarek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shaohua Li <shli@kernel.org>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <ad94b647-4ba0-4ae9-be8f-6fe7e9406def@zytor.com>
Sender: linux-kbuild-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/17/17 14:32, H. Peter Anvin wrote:
> 
> NAK.  Fix your compiler, or use a wrapper script or something.  It is
> absolutely *not* acceptable to disable this since future versions of
> clang *should* support that.
> 
> That being said, it might make sense to look for a key pattern like
> "(un|not )supported" on stderr the try-run macro.  Is there really no
> -Wno- or -Werror= option to turn off this craziness?
> 

Well, guess what... I found it myself.

-W{no-,error=}ignored-optimization-argument

Either variant will make this sane.

	-hpa


