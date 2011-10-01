From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: Fwd: crypto accelerator driver problems
Date: Sat, 1 Oct 2011 12:38:19 +0330
Message-ID: <CAFuf8QPV248w=S06s7mz=vLzYdsrjQ7nvChui-3P3kgMzV8vHA@mail.gmail.com>
References: <AANLkTinGGsjgBKD1LqhL2u4DOU_XrACK4D67nHfPnL5e@mail.gmail.com>
 <20101230211900.GA22742@gondor.apana.org.au> <AANLkTinm8uy34ni_4XFLZTcdkndy0B_jeFXag0onxA66@mail.gmail.com>
 <AANLkTin8au=98mmfsaJjOSyJNibk3foZWihj6EGTGWK-@mail.gmail.com>
 <20110126070939.GA18150@gondor.apana.org.au> <AANLkTi=m0jVWSqR1FNX9r9HH32LbA0aWJxSQtLd_VszW@mail.gmail.com>
 <20110126233315.GB26664@gondor.apana.org.au> <CAFuf8QO1gG2WUMmgywHANBHgBj1D8RV8xkJvMYOdiJSovduG+A@mail.gmail.com>
 <20110705065351.GA31107@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54517 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1JAJIu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Oct 2011 05:08:50 -0400
Received: by bkbzt4 with SMTP id zt4so2691332bkb.19
        for <linux-crypto@vger.kernel.org>; Sat, 01 Oct 2011 02:08:49 -0700 (PDT)
In-Reply-To: <20110705065351.GA31107@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

Referring my previous posts in crypto list related to our hardware aes
accelerator project, I finally could deploy device in IPSec successfully. As I
mentioned earlier, my driver registers itself in kernel as blkcipher for
cbc(aes) as follows:

static struct crypto_alg my_cbc_alg = {
	.cra_name		=	"cbc(aes)",
	.cra_driver_name	=	"cbc-aes-my",
	.cra_priority		=	400,
	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
							CRYPTO_ALG_NEED_FALLBACK,
	.cra_init			=	fallback_init_blk,
	.cra_exit			=	fallback_exit_blk,
	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
	.cra_ctxsize		=	sizeof(struct my_aes_op),
 	.cra_alignmask		=	15,
	.cra_type			=	&crypto_blkcipher_type,
	.cra_module			=	THIS_MODULE,
	.cra_list			=   LIST_HEAD_INIT(my_cbc_alg.cra_list),
	.cra_u				=	{
		.blkcipher	=	{
			.min_keysize	=	AES_MIN_KEY_SIZE,
			.max_keysize	=	AES_MIN_KEY_SIZE,
			.setkey			=	my_setkey_blk,
			.encrypt		=	my_cbc_encrypt,
			.decrypt		=	my_cbc_decrypt,
			.ivsize			=	AES_IV_LENGTH,
		}
	}
};

And my_cbc_encrypt function as PSEUDO/real code (for simplicity of
representation) is as:

static int
my_cbc_encrypt(struct blkcipher_desc *desc,
		  struct scatterlist *dst, struct scatterlist *src,
		  unsigned int nbytes)
{
		SOME__common_preparation_and_initializations;	
		
		spin_lock_irqsave(&myloc, myflags);
		send_request_to_device(&dev); /*sends request to device. After
					    processing request,device writes
					    result to destination*/
		while(!readl(complete_flag)); /*here we wait for a flag in
			  device register space indicating completion. */
		spin_unlock_irqrestore(&mylock, myflags);
	
	
}

With above code, I can successfully test IPSec gateway equipped with our
hardware and get a 200Mbps throughput using Iperf. Now I am facing with another
poblem. As I mentioned earlier, our hardware has 4 aes engines builtin. With
above code I only utilize one of them.
>From this point, we want to go a step further and utilize more than one aes
engines of our device. Simplest solution appears to me is to deploy
pcrypt/padata, made by Steffen Klassert. First instantiate in a dual
core gateway :
	modprobe tcrypt alg="pcrypt(authenc(hmac(md5),cbc(aes)))" type=3
 and test again. Running Iperf now gives me a very low
throughput about 20Mbps while dmesg shows the following:

   BUG: workqueue leaked lock or atomic: kworker/0:1/0x00000001/10
       last function: padata_parallel_worker+0x0/0x80
   Pid: 10, comm: kworker/0:1 Not tainted 2.6.37 #1
   Call Trace:
    [<c03e2d7d>] ? printk+0x18/0x1b
    [<c014a2b7>] process_one_work+0x177/0x370
    [<c0199980>] ? padata_parallel_worker+0x0/0x80
    [<c014c467>] worker_thread+0x127/0x390
    [<c014c340>] ? worker_thread+0x0/0x390
    [<c014fd74>] kthread+0x74/0x80
    [<c014fd00>] ? kthread+0x0/0x80
    [<c01033f6>] kernel_thread_helper+0x6/0x10
   BUG: scheduling while atomic: kworker/0:1/10/0x00000002
   Modules linked in: pcrypt my_aes2 binfmt_misc bridge stp
bnep sco rfcomm l2cap crc16 bluetooth rfkill ppdev acpi_cpufreq mperf
cpufreq_stats cpufreq_conservative cpufreq_ondemand cpufreq_userspace
cpufreq_powersave freq_table pci_slot sbs container video output sbshc battery
iptable_filter ip_tables x_tables decnet ctr twofish_i586 twofish_generic
twofish_common camellia serpent blowfish cast5 aes_i586 aes_generic xcbc rmd160
sha512_generic sha256_generic crypto_null af_key ac lp snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_pcm_oss evdev snd_mixer_oss snd_pcm psmouse
serio_raw snd_seq_dummy pcspkr parport_pc parport snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event option usb_wwan snd_seq usbserial snd_timer
snd_seq_device button processor iTCO_wdt iTCO_vendor_support snd intel_agp
soundcore intel_gtt snd_page_alloc agpgart shpchp pci_hotplug ext3 jbd mbcache
sr_mod cdrom sd_mod sg ata_generic pata_jmicron ata_piix pata_acpi libata floppy
r8169 mii
  scsi_mod uhci_hcd ehci_hcd usbcore thermal fan fuse
   Pid: 10, comm: kworker/0:1 Not tainted 2.6.37 #1
   Call Trace:
    [<c012d459>] __schedule_bug+0x59/0x70
    [<c03e3757>] schedule+0x6a7/0xa70
    [<c0105bf7>] ? show_trace_log_lvl+0x47/0x60
    [<c03e2be9>] ? dump_stack+0x6e/0x75
    [<c014a308>] ? process_one_work+0x1c8/0x370
    [<c0199980>] ? padata_parallel_worker+0x0/0x80
    [<c014c51f>] worker_thread+0x1df/0x390
    [<c014c340>] ? worker_thread+0x0/0x390
    [<c014fd74>] kthread+0x74/0x80
    [<c014fd00>] ? kthread+0x0/0x80
    [<c01033f6>] kernel_thread_helper+0x6/0x10

I must emphasize again that goal of deploying pcrypt/padata is to have more than
one request present in our hardware (e.g. in a quad cpu system we'll have 4
encryption and 4 decryption requests sent into our hardware). Also I tried using
pcrypt/padata in a single cpu system with one change in pcrypt_init_padata
function of pcrypt.c: passing 4 as max_active parameter of alloc_workqueue.
In fact I called alloc_workqueue as:

alloc_workqueue(name, WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 4);
instead of :
alloc_workqueue(name, WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 1);

But this did not give me 4 encryption requests.
I know that one promising solution might be to choose ablkcipher over blkcipher
scheme, but as we need a quicker solution and we are pressed with
time, I request
 your comments about my problem.
Can I solve my problem with pcrypt/padata anyway with any change in my current
 blkcipher driver en/deccrypt function or in pcrypt iself? Or should I
take another way?

Please take in mind that minor changes to our current solution is highly
recommended because of our little time.

Thanks in advance,

Hamid.
