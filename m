From: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v6 13/18] wireless/lib80211: Convert from ahash to shash
Date: Wed, 25 Jul 2018 09:24:53 +0200
Message-ID: <1532503493.3223.0.camel@sipsolutions.net>
References: <20180724164936.37477-1-keescook@chromium.org>
         <20180724164936.37477-14-keescook@chromium.org>
         (sfid-20180724_184958_869692_1891A71D)
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowells@redhat.com>,
        Tudor-Dan Ambarus
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180724164936.37477-14-keescook@chromium.org> (sfid-20180724_184958_869692_1891A71D)
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2018-07-24 at 09:49 -0700, Kees Cook wrote:
> In preparing to remove all stack VLA usage from the kernel[1], this
> removes the discouraged use of AHASH_REQUEST_ON_STACK in favor of
> the smaller SHASH_DESC_ON_STACK by converting from ahash-wrapped-shash
> to direct shash. By removing a layer of indirection this both improves
> performance and reduces stack usage. The stack allocation will be made
> a fixed size in a later patch to the crypto subsystem.
> 
I think you sent this before - it should be in net-next now.

johannes
