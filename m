From: David McCullough <david_mccullough@au.securecomputing.com>
Subject: Re: problem using cryptosft
Date: Thu, 7 Dec 2006 21:04:40 +1000
Message-ID: <20061207110440.GA7448@au.securecomputing.com>
References: <4574EEC1.6060503@gdatech.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:55566 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1032029AbWLGLEp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Dec 2006 06:04:45 -0500
To: Tripurari Prasad <tripurari.prasad@gdatech.co.in>
Content-Disposition: inline
In-Reply-To: <4574EEC1.6060503@gdatech.co.in>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Jivin Tripurari Prasad lays it down ...
> Hi
> 	I have been trying to use OCF release 0cf-linux-20060331
> for software acceleration in x86 machine.
> As given I have upgraded the openssl to version 0.9.8a and applied the ssl 
> patch
> Also added the ocf as module in kernel and enabled the OCF
> There are No Hardware engine I am using.I intend to use software engine only
> 
> however when i try to run the test using openssl
> i get the errors saying inavalid engine .
> 
> 
> invalid engine "cryptosoft"

cryptosoft is the kernel driver,  cryptodev is the "engine",  though you
do not need to specify it.  If you have cryptodev loaded and a patched
openssl,  it will use the cryptodev engine by default.

Cheers,
Davidm

> 5733:error:25066067:DSO support routines:DLFCN_LOAD:could not load the 
> shared 
> library:dso_dlfcn.c:162:filename(/usr/local/ssl/lib/engines/libcryptosoft.so):
> /usr/local/ssl/lib/engines/libcryptosoft.so: cannot open shared object 
> file: No such file or directory
> 5733:error:25070067:DSO support routines:DSO_load:could not load the 
> shared library:dso_lib.c:244:
> 5733:error:260B6084:engine routines:DYNAMIC_LOAD:dso not 
> found:eng_dyn.c:450:
> 5733:error:2606A074:engine routines:ENGINE_by_id:no such 
> engine:eng_list.c:415:id=cryptosoft
> 5733:error:25066067:DSO support routines:DLFCN_LOAD:could not load the 
> shared library:dso_dlfcn.c:162:filename(libcryptosoft.so): 
> libcryptosoft.so: cannot open shared object file: No such file or directory
> 5733:error:25070067:DSO support routines:DSO_load:could not load the  
> shared library:dso_lib.c:244:
> 5733:error:260B6084:engine routines:DYNAMIC_LOAD:dso not 
> found:eng_dyn.c:450:
> You have chosen to measure elapsed time instead of user CPU time.
> To get the most accurate results, try to run this
> program when this computer is idle.
> Doing des-cbc for 3s on 16 size blocks: 8672638 des-cbc's in 3.00s
> Doing des-cbc for 3s on 64 size blocks: 3367797 des-cbc's in 3.00s
> Doing des-cbc for 3s on 256 size blocks: 872436 des-cbc's in 3.00s
> Doing des-cbc for 3s on 1024 size blocks: 220186 des-cbc's in 3.00s
> Doing des-cbc for 3s on 8192 size blocks: 27519 des-cbc's in 3.00s
> OpenSSL 0.9.8a 11 Oct 2005
> built on: Fri Dec  1 20:40:05 IST 2006
> options:bn(64,32) md2(int) rc4(idx,int) des(ptr,risc1,16,long) 
> aes(partial) idea(int) blowfish(idx)
> compiler: gcc -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H 
> -mcpu=pentium -DL_ENDIAN -DTERMIO -O3 -fomit-frame-pointer -Wall 
> -DOPENSSL_BN_ASM_PART_WORDS -DOPENSSL_IA32_SSE2 -DSHA1_ASM -DMD5_ASM 
> -DRMD160_ASM -DAES_ASM
> available timing options: TIMES TIMEB HZ=100 [sysconf value]
> timing function used: ftime
> The 'numbers' are in 1000s of bytes per second processed.
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
> bytes
> des-cbc          46223.25k    71846.34k    74447.87k    75156.82k    
> 75145.22k
> [root@localhost /]#
> -
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
David McCullough,  david_mccullough@securecomputing.com,   Ph:+61 734352815
Secure Computing - SnapGear  http://www.uCdot.org http://www.cyberguard.com
