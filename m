From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Wed, 18 Jul 2018 11:14:20 -0400
Message-ID: <CACXcFmk7D5t9yg9VxhKZgMvqK-LmFF0d7Dh9A3hsoGTfzzeM8A@mail.gmail.com>
References: <20180718014344.1309-1-tytso@mit.edu> <20180718015154.GE3489@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718015154.GE3489@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 17, 2018 at 9:51 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:

> On Tue, Jul 17, 2018 at 09:43:44PM -0400, Theodore Ts'o wrote:
>> This gives the user building their own kernel (or a Linux
>> distribution) the option of deciding whether or not to trust the CPU's
>> hardware random number generator (e.g., RDRAND for x86 CPU's) as being
>> correctly implemented and not having a back door introduced (perhaps
>> courtesy of a Nation State's law enforcement or intelligence
>> agencies).
>>
>> This will prevent getrandom(2) from blocking, if there is a
>> willingness to trust the CPU manufacturer.
>>
>> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>
> Note, I had meant to tag this with an RFC.  I'm not sure I really want
> to push this to Linus yet.  If you have an opinion, let me know.

I had something like this in patches I suggested as RFC a couple of
years back. Those patches were rejected for other reasons, quite
likely valid ones.

My version was not binary like this:

>> +config RANDOM_TRUST_CPU
>> +       bool "Trust the CPU manufacturer to initialize Linux's CRNG"

Instead, I had a compile-time option to choose a number 0-32
for how much entropy to assume a 32-bit value from the HWRNG
contains. Default was something less than 32. I debated values
in the 24-30 range, don't recall what I chose & don't think it
Matters hugely.

Is that a better approach than the binary choice?
