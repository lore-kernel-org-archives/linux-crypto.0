From: Ken Moffat <zarniwhoop73@googlemail.com>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Wed, 18 Jul 2018 18:36:08 +0100
Message-ID: <CANVEwpY2H+OBnYNAf15bRRbmepFCerWrisLiLQ=h3+_692MY7A@mail.gmail.com>
References: <20180718014344.1309-1-tytso@mit.edu> <20180718015154.GE3489@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718015154.GE3489@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18 July 2018 at 02:51, Theodore Y. Ts'o <tytso@mit.edu> wrote:
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

(Apologies if this is a duplicate reply, I misread the tiny text in gmail a=
sking
me if it was ok to send non plain text (dunno what caused that), so I guess
the first version went to /dev/null, at least as far as the list is concern=
ed.)

On my haswell, since 4.16.4 and the corresponding 4.17-rc. my (sysv)
bootscript to start unbound hangs for a couple of minutes unless I use the
keyboard. Same on my kaveri.  Those both lack spinning rust, but on two
other SSD-only machines (ryzen, phenom) the security fix did not slow down
the boot.

So, since I've got better things to do than _worry_ about than whether my
government, or yours, is spying on me, I would prefer to have the option to
take the risk on the machines that will then boot faster.

=C4=B8en
