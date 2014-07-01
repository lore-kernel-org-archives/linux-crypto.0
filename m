From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans-2StjZFpD7GcAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ARM: convert all "mov.* pc,
	reg" to "bx reg" for ARMv6+ (part1)
Date: Tue, 1 Jul 2014 17:42:42 +0100
Message-ID: <yw1x4mz1f2t9.fsf@unicorn.mansr.com>
References: <E1X20mL-00083I-Sv@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: <davinci-linux-open-source-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>,
        <linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>,
        <linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
To: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Return-path: <davinci-linux-open-source-bounces+gld-davinci-linux-open-source=gmane.org-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
In-Reply-To: <E1X20mL-00083I-Sv-eh5Bv4kxaXIANfyc6IWni62ZND6+EDdj@public.gmane.org> (Russell King's
	message of "Tue, 01 Jul 2014 17:19:33 +0100")
List-Unsubscribe: <http://linux.davincidsp.com/mailman/options/davinci-linux-open-source>,
	<mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=unsubscribe>
List-Archive: <http://linux.davincidsp.com/pipermail/davinci-linux-open-source>
List-Post: <mailto:davinci-linux-open-source-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
List-Help: <mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=help>
List-Subscribe: <http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source>,
	<mailto:davinci-linux-open-source-request-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org?subject=subscribe>
Sender: <davinci-linux-open-source-bounces+gld-davinci-linux-open-source=gmane.org-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org>
Errors-To: davinci-linux-open-source-bounces+gld-davinci-linux-open-source=gmane.org-VycZQUHpC/PFrsHnngEfi1aTQe2KTcn/@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org> writes:

> ARMv6 and greater introduced a new instruction ("bx") which can be used
> to return from function calls.  Recent CPUs perform better when the
> "bx lr" instruction is used rather than the "mov pc, lr" instruction,
> and this sequence is strongly recommended to be used by the ARM
> architecture manual (section A.4.1.1).
>
> We provide a new macro "ret" with all its variants for the condition
> code which will resolve to the appropriate instruction.

When the source register is not "lr" the name "ret" is a misnomer since
only the "bx lr" instruction is predicted as a function return.  The
"bx" instruction with other source registers uses the normal prediction
mechanisms, leaving the return stack alone, and should not be used for
function returns.  Any code currently using another register to return
from a function should probably be modified to use lr instead, unless
there are special reasons for doing otherwise.  If code jumping to an
address in a non-lr register is not a return, using the "ret" name will
make for some rather confusing reading.

I would suggest either using a more neutral name than "ret" or adding an
alias to be used for non-return jumps so as to make the intent clearer.

-- =

M=E5ns Rullg=E5rd
mans-2StjZFpD7GcAvxtiuMwx3w@public.gmane.org
